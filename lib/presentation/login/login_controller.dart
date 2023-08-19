import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';
import 'package:skeleton_app/domain/usecases/login_usecase.dart';

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
    super.onInit();
  }

  void _loadInfo() async {
    rememberUsername.value = await localRepository.readRemeberUsername();
    if (rememberUsername.value) {
      usernameController.text = await localRepository.readUsername();
    }
    change([], status: RxStatus.success());
  }

  void updateRememberUsename(bool? value) {
    rememberUsername.value = value ?? false;
    localRepository.updateRemeberUsername(value);
  }

  void updatePasswordVisibility() {
    isObscure.value = !isObscure.value;
  }

  Future<User?> signIn() async {
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
    final body = {
      'username': usernameController.text,
      'password': passwordController.text,
      'remember_me': rememberUsername.value,
    };
    final res = await LoginUsecase(apiRepository).signIn(body);
    MessagesUtils.dismissLoading();
    return res.fold(
      (failure) async {
        if (failure is UnauthorizedFailure) {
          MessagesUtils.errorSnackbar(
            "Credenciales Inválidas",
            "¡Usuario y/o contraseña inválidos!",
          );
          return null;
        }
        return null;
      },
      (dynamic result) {
        // localRepository.storeToken(result.token, result.expiresAt);
        localRepository.updateCredentials(
          usernameController.text,
          passwordController.text,
        );
        // TODO: Change this for result.user
        final userRresult = User(
          id: 1,
          name: 'José Anibal Tejada Jiménez',
          username: 'jose',
          image: '',
          isAdmin: 0,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );
        localRepository.storeUser(jsonEncode(userRresult.toJson()));
        return userRresult;
      },
    );
  }
}
