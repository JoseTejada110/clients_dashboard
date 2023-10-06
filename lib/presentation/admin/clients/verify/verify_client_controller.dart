import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/user_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';
import 'package:bisonte_app/domain/usecases/notifications_usecase.dart';
import 'package:bisonte_app/presentation/admin/clients/admin_clients_controller.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class VerifyClientController extends GetxController {
  VerifyClientController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    client = Get.arguments as UserModel;
    super.onInit();
  }

  late UserModel client;

  void showConfirmation(BuildContext context) async {
    if (client.isVerified()) {
      Get.dialog(
        const DialogErrorPlaceholcer(
          message: ErrorResponse(
              title: 'Cliente Verificado',
              message: 'Este cliente ya está verificado'),
        ),
      );
      return;
    }
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Verificar Cliente',
      subtitle:
          const Text('¿Seguro que deseas marcar este usuario como verificado?'),
      onConfirm: () {
        Navigator.pop(context);
        verifyClient();
      },
      onCancel: Get.back,
    );
  }

  Future<void> verifyClient() async {
    MessagesUtils.showLoading(message: 'Verificando...');
    const verifiedStatus = 'Verificado';
    final clientData = {
      'status': verifiedStatus,
      'verified_by': Utils.getUserReference(),
    };
    final params = FirebaseParamsRequest(
      documentReference:
          FirebaseFirestore.instance.collection('users').doc(client.id),
      data: clientData,
    );
    final result = await GeneralUsecase(apiRepository).writeData(params);
    MessagesUtils.dismissLoading();

    result.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: verifyClient),
      (r) {
        NotificationUsecase().sendNotificationToUser(
          client.id,
          '¡Has sido verificado!',
          'Has sido verificado en Bisonte App. ¡Realiza tu depósito ahora!',
        );
        client.status = verifiedStatus;
        Get.find<AdminClientsController>().refresh();
        Get.back();
        MessagesUtils.successSnackbar(
          'Usuario Verificado',
          '${client.name} ha sido verificado con éxito.',
        );
      },
    );
  }
}
