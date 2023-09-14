import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';
import 'package:skeleton_app/presentation/admin/clients/admin_clients_controller.dart';

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
        // TODO: Enviar notificación al cliente
        // TODO: Agregar campo, verificado por
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
