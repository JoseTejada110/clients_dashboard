import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';
import 'package:skeleton_app/domain/usecases/login_usecase.dart';
import 'package:skeleton_app/domain/usecases/notifications_usecase.dart';

class LoginController extends GetxController with StateMixin {
  LoginController({required this.apiRepository, required this.localRepository});
  final ApiRepositoryInteface apiRepository;
  final LocalStorageRepositoryInterface localRepository;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool isObscure = true.obs;
  RxBool rememberUsername = false.obs;

  @override
  void onInit() {
    _loadInfo();
    _requestNotificationPermission();
    super.onInit();
  }

  void _loadInfo() async {
    rememberUsername.value = await localRepository.readRemeberUsername();
    if (rememberUsername.value) {
      usernameController.text = await localRepository.readUsername();
    }
    change([], status: RxStatus.success());
  }

  void _requestNotificationPermission() async {
    NotificationUsecase().requestNotificationPermission();
  }

  void updateRememberUsename(bool? value) {
    rememberUsername.value = value ?? false;
    localRepository.updateRemeberUsername(value);
  }

  void updatePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  Future<UserModel?> signIn() async {
    if (usernameController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Usuario Obligatorio',
        'Debe introducir el nombre de usuario',
      );
      return null;
    }
    if (passwordController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Contraseña Obligatoria',
        'Debe introducir la contraseña',
      );
      return null;
    }
    MessagesUtils.showLoading();
    final res = await LoginUsecase(apiRepository).signIn(
      usernameController.text,
      passwordController.text,
    );
    return res.fold(
      (failure) async {
        MessagesUtils.dismissLoading();
        if (failure is UnauthorizedFailure) {
          MessagesUtils.errorSnackbar(
            "Credenciales Inválidas",
            "Correo y/o contraseña inválidos!",
          );
          return null;
        }
        final message = getMessageFromFailure(failure);
        MessagesUtils.errorSnackbar(
          message.title,
          message.message,
        );
        return null;
      },
      (UserModel result) async {
        localRepository.updateCredentials(
          usernameController.text,
          passwordController.text,
        );
        if (await NotificationUsecase().requestNotificationPermission()) {
          NotificationUsecase().subscribeToTopic(
            result.isAdmin
                ? AvailableTopic.allAdmins
                : AvailableTopic.allClients,
          );
          _saveUserDeviceToken(result.id);
        }
        MessagesUtils.dismissLoading();
        localRepository.storeUser(
          jsonEncode(result.toJson(isToStoreInLocal: true)),
        );
        return result;
      },
    );
  }

  Future<void> _saveUserDeviceToken(String uid) async {
    print('UID: $uid');
    final token = await NotificationUsecase().getDeviceToken();
    print('TOKEN: $token');
    if (token != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .doc(token)
          .set({
        'date': FieldValue.serverTimestamp(),
        'token': token,
        'platform': Platform.operatingSystem,
      });
    }
  }
}
