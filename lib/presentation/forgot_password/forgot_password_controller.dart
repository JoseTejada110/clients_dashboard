import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;
  final emailController = TextEditingController();

  Future<void> resetPassword() async {
    if (!_validateFields()) return;
    try {
      MessagesUtils.showLoading(message: 'Enviando email...');
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      MessagesUtils.dismissLoading();
      Get.back();
      MessagesUtils.successSnackbar(
        'Email Enviado',
        'Se ha enviado un correo electrónico para restablecer su contraseña',
      );
    } on FirebaseAuthException catch (e) {
      MessagesUtils.dismissLoading();
      ErrorResponse? error;
      switch (e.code) {
        case 'user-not-found':
          error = const ErrorResponse(
            title: 'Usuario no encontrado',
            message:
                'No existe un usuario registrado con este correo. Es posible que este usuario haya sido eliminado',
          );
          break;
        default:
      }
      if (error != null) {
        Get.dialog(DialogErrorPlaceholcer(message: error));
      }
    }
  }

  bool _validateFields() {
    ErrorResponse? error;
    if (emailController.text.isEmpty) {
      error = const ErrorResponse(
        title: 'Email Obligatorio',
        message: 'Debes especificar tú correo electrónico',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text);
    if (!emailValid) {
      error = const ErrorResponse(
        title: 'Email Inválido',
        message: 'El correo electrónico especificado no es válido',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    return true;
  }
}
