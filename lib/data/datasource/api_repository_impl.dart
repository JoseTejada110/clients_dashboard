import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:skeleton_app/core/error_handling/exceptions.dart';
import 'package:skeleton_app/data/models/account_model.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';

class ApiRepositoryImpl extends ApiRepositoryInteface {
  static const timeoutLimit = Duration(seconds: 30);
  @override
  Future<List<T>> readData<T>(FirebaseParamsRequest params) async {
    try {
      Query<Map<String, dynamic>> query =
          FirebaseFirestore.instance.collection(params.collection);

      // Agregando los parámetros where
      if (params.whereParams != null) {
        for (FirebaseWhereParams whereParams in params.whereParams!) {
          query = query.where(
            whereParams.field,
            isEqualTo: whereParams.isEqualTo,
            isNotEqualTo: whereParams.isNotEqualTo,
            isLessThan: whereParams.isLessThan,
            isLessThanOrEqualTo: whereParams.isLessThanOrEqualTo,
            isGreaterThan: whereParams.isGreaterThan,
            isGreaterThanOrEqualTo: whereParams.isGreaterThanOrEqualTo,
            arrayContains: whereParams.arrayContains,
            arrayContainsAny: whereParams.arrayContainsAny,
            whereIn: whereParams.whereIn,
            whereNotIn: whereParams.whereNotIn,
            isNull: whereParams.isNull,
          );
        }
      }
      if (params.orderBy != null) {
        query = query.orderBy(
          params.orderBy!.field,
          descending: params.orderBy!.descending,
        );
      }

      final querySnapshot = await query.get().timeout(timeoutLimit);

      final List<T> result = [];

      // Bloque try para identificar una excepción al parsear los datos del modelo
      try {
        for (var element in querySnapshot.docs) {
          result.add(params.parser == null
              ? element.data()
              : params.parser!(element.data()..addAll({'id': element.id})));
        }
      } catch (e) {
        print('dataParsingFailure: $e');
        throw DataParsingException();
      }
      print('RESULT: $result');
      return result;
    } on FirebaseException catch (e) {
      print('FIREBASE EXCEPTION: $e');
      print(e.code);
      throw _handleFirebaseException(e.code);
    } catch (e) {
      if (e is TimeoutException) {
        throw CustomTimeoutException();
      }
      if (e is SocketException) {
        if (e.message.trim() == 'Connection refused' ||
            e.message.trim() ==
                'El equipo remoto rechazó la conexión de red.') {
          throw UnhandledException();
        }
        throw NoConnectionException();
      }
      print('UNHANDLED EXCEPTION: $e');
      rethrow;
    }
  }

  @override
  Future<String> writeData(FirebaseParamsRequest params) async {
    try {
      if (params.documentReference != null) {
        await params.documentReference!
            .update(params.data!)
            .timeout(timeoutLimit);
        return params.documentReference!.id;
      } else {
        final storedDocument = await FirebaseFirestore.instance
            .collection(params.collection)
            .add(params.data!)
            .timeout(timeoutLimit);
        return storedDocument.id;
      }
    } on FirebaseException catch (e) {
      print('FIREBASE EXCEPTION: $e');
      print(e.code);
      throw _handleFirebaseException(e.code);
    } catch (e) {
      print('UNHANDLED EXCEPTION: $e');
      if (e is TimeoutException) {
        throw CustomTimeoutException();
      }
      if (e is SocketException) {
        if (e.message.trim() == 'Connection refused' ||
            e.message.trim() ==
                'El equipo remoto rechazó la conexión de red.') {
          throw UnhandledException();
        }
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  @override
  Future<T> executeFirebaseQueries<T>(
      Future<dynamic> Function() queries) async {
    try {
      return await queries();
    } on FirebaseException catch (e) {
      print('FIREBASE EXCEPTION: $e');
      print(e.code);
      throw _handleFirebaseException(e.code);
    } catch (e) {
      print('UNHANDLED EXCEPTION: $e');
      if (e is TimeoutException) {
        throw CustomTimeoutException();
      }
      if (e is SocketException) {
        if (e.message.trim() == 'Connection refused' ||
            e.message.trim() ==
                'El equipo remoto rechazó la conexión de red.') {
          throw UnhandledException();
        }
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  @override
  Future<String> signupUser(
    String email,
    String password,
    Map<String, dynamic> userData,
    File identificationImage,
    File faceImage,
    File addressProofImage,
  ) async {
    try {
      // REGISTRANDO USUARIO
      final credentialsResult =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = credentialsResult.user?.uid;

      // ALMACENANDO IMÁGENES Y OBTENIENDO URLs
      final storageRef = FirebaseStorage.instance.ref();
      final identificationImageRef = storageRef.child(
        'images/users/$uid/identification_image',
      );
      final faceImageRef = storageRef.child('images/users/$uid/face_image');
      final addressProofImageRef = storageRef.child(
        'images/users/$uid/address_proof_image',
      );
      await Future.wait([
        identificationImageRef.putFile(identificationImage),
        faceImageRef.putFile(faceImage),
        addressProofImageRef.putFile(addressProofImage),
      ]);
      final urls = await Future.wait([
        identificationImageRef.getDownloadURL(),
        faceImageRef.getDownloadURL(),
        addressProofImageRef.getDownloadURL(),
      ]);

      // CREANDO CUENTA/WALLET DEL USUARIO
      final firestoreInstance = FirebaseFirestore.instance;
      final accountResult =
          await firestoreInstance.collection('/accounts').add({
        'net_balance': 0,
        'invested_amount': 0,
      });

      // CREANDO USUARIO EN LA BASE DE DATOS
      userData.addAll({
        'identification_image': urls[0],
        'face_image': urls[1],
        'address_proof_image': urls[2],
        'accounts': [accountResult],
      });
      await firestoreInstance.collection('/users').doc(uid).set(userData);

      return uid!;
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('FIREBASE AUTH EXCEPTION: $e');
        throw _handleFirebaseAuthException(e.code);
      }
      if (e is FirebaseException) {
        print('FIREBASE EXCEPTION: $e');
        throw _handleFirebaseException(e.code);
      }
      print('UNHANDLED EXCEPTION: $e');
      if (e is TimeoutException) {
        throw CustomTimeoutException();
      }
      if (e is SocketException) {
        if (e.message.trim() == 'Connection refused' ||
            e.message.trim() ==
                'El equipo remoto rechazó la conexión de red.') {
          throw UnhandledException();
        }
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  @override
  Future<UserModel> signinUser(String email, String password) async {
    try {
      final signinResult =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final uid = signinResult.user!.uid;
      final userResult =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      if (!userResult.exists) {
        throw UnauthorizedException(
          message: {
            'error_title': 'Credenciales Inválidas',
            'error_message':
                'No hemos encontrado un usuario con las credenciales proporcionadas.',
          },
        );
      }

      // Obteniendo los datos del usuario logueado en formato JSON
      final userData = userResult.data()!
        ..addAll(
          {
            'id': userResult.id,
            'bank_accounts': FirebaseFirestore.instance
                .collection('users')
                .doc(userResult.id)
                .collection('bank_accounts'),
          },
        );

      // Cargando cuentas de los usuarios
      final List<Account> accounts = [];
      for (DocumentReference<Map<String, dynamic>> reference
          in userData['accounts']) {
        final document = await reference.get();
        accounts.add(
          Account.fromJson(document.data()!..addAll({'id': document.id})),
        );
      }
      userData['accounts'] = accounts;

      return UserModel.fromJson(userData, isAccountsLoaded: true);
    } catch (e) {
      if (e is FirebaseAuthException) {
        print('FIREBASE AUTH EXCEPTION: $e');
        throw _handleFirebaseAuthException(e.code);
      }
      if (e is FirebaseException) {
        print('FIREBASE EXCEPTION: $e');
        throw _handleFirebaseException(e.code);
      }
      print('UNHANDLED EXCEPTION: $e');
      if (e is TimeoutException) {
        throw CustomTimeoutException();
      }
      if (e is SocketException) {
        if (e.message.trim() == 'Connection refused' ||
            e.message.trim() ==
                'El equipo remoto rechazó la conexión de red.') {
          throw UnhandledException();
        }
        throw NoConnectionException();
      }
      rethrow;
    }
  }

  // Manage firebase auth exceptions
  Exception _handleFirebaseAuthException(String errorCode) {
    print(errorCode);
    switch (errorCode) {
      case 'email-already-in-use':
        return UnauthorizedException(
          message: {
            'error_title': 'Email Existente',
            'error_message':
                'Ya existe un usuario registrado con este correo electrónico.',
          },
        );
      case 'invalid-email':
        return UnauthorizedException(
          message: {
            'error_title': 'Email Inválido',
            'error_message':
                'El correo electrónico proporcionado tiene un formato inválido.',
          },
        );
      case 'user-not-found':
        return UnauthorizedException();
      case 'wrong-password':
        return UnauthorizedException();
      case 'network-request-failed':
        return NoConnectionException();
    }
    return UnhandledException();
  }

  // Manage firebase exceptions
  Exception _handleFirebaseException(String errorCode) {
    print(errorCode);
    switch (errorCode) {
      case 'permission-denied':
        return UnauthorizedException();
      case 'network-request-failed':
        return NoConnectionException();
    }
    return UnhandledException();
  }
}
