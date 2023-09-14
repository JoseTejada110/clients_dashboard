import 'dart:io';

import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';

abstract class ApiRepositoryInteface {
  Future<List<T>> readData<T>(FirebaseParamsRequest params);
  Future<String> writeData(FirebaseParamsRequest params);
  Future<String> signupUser(
    String email,
    String password,
    Map<String, dynamic> userData,
    File identificationImage,
    File faceImage,
    File addressProofImage,
  );
  Future<UserModel> signinUser(String email, String password);
  Future<T> executeFirebaseQueries<T>(Future<dynamic> Function() queries);
}
