import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/usecases/notifications_usecase.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class BulkNotificationController extends GetxController {
  BulkNotificationController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  final notificationTitleController = TextEditingController();
  final notificationTitleFocus = FocusNode();
  final notificationMessageController = TextEditingController();
  final notificationMessageFocus = FocusNode();

  void showConfirmation(BuildContext context) async {
    final isValidFields = _validateFields();
    if (!isValidFields) return;
    const recipientType = 'clientes';
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Confirmar Mensaje',
      subtitle: const Text(
          '¿Seguro que deseas enviar la notificación a todos los $recipientType?'),
      onConfirm: () {
        Navigator.pop(context);
        sendBulkNotification();
      },
      onCancel: Get.back,
    );
  }

  Future<void> sendBulkNotification() async {
    MessagesUtils.showLoading(message: 'Enviando...');
    final isSent = await NotificationUsecase().sendNotificationToTopic(
      notificationTitleController.text,
      notificationMessageController.text,
      AvailableTopic.allClients.name,
    );
    MessagesUtils.dismissLoading();
    if (isSent) {
      Get.back();
      MessagesUtils.successSnackbar(
        'Notificación Enviada',
        'La notificación ha sido enviada con éxito',
      );
    } else {
      const error = ErrorResponse(
        title: 'No ha sido posible enviar la notificación',
        message:
            'Algo ha salido mal al enviar la notificación. Intenta de nuevo más tarde.',
      );
      Get.dialog(const DialogErrorPlaceholcer(message: error));
    }
  }

  bool _validateFields() {
    ErrorResponse? error;
    if (notificationMessageController.text.isEmpty) {
      error = const ErrorResponse(
        title: 'Introduce el título',
        message: 'El título de la notificación es obligatorio',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error))
          .then((value) => notificationTitleFocus.requestFocus());
      return false;
    }
    if (notificationMessageController.text.isEmpty) {
      error = const ErrorResponse(
        title: 'Introduce el mensaje',
        message: 'El mensaje de la notificación es obligatorio',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error))
          .then((value) => notificationMessageFocus.requestFocus());
      return false;
    }
    return true;
  }
}
