import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/investment_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';
import 'package:bisonte_app/domain/usecases/notifications_usecase.dart';
import 'package:bisonte_app/presentation/admin/investments/admin_investments_controller.dart';

class CreateInvestmentsController extends GetxController {
  CreateInvestmentsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    _loadSelectedData();
    super.onInit();
  }

  void _loadSelectedData() {
    if (Get.arguments == null) return;
    investment = Get.arguments as Investment;
    investmentNameController.text = investment!.name;
    investmentReturnController.text =
        Constants.decimalFormat.format(investment!.returnPercentage);
    minAmountController.text =
        Constants.decimalFormat.format(investment!.minimumInvestment);
    maxAmountController.text =
        Constants.decimalFormat.format(investment!.maximumInvestment);
    beginDate.value = investment!.initialDate;
    endDate.value = investment!.endDate;
    isAvailable.value = investment!.isAvailable;
  }

  //
  Investment? investment;
  final investmentNameController = TextEditingController();
  final investmentReturnController = TextEditingController();
  final minAmountController = TextEditingController(text: '1.00');
  final maxAmountController = TextEditingController(text: '1.00');
  final beginDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;
  final isAvailable = true.obs;

  void pickBeginDate(DateTime value) => beginDate.value = value;
  void pickEndDate(DateTime value) => endDate.value = value;
  void switchIsAvailable(bool? value) => isAvailable.value = value ?? false;

  Future<void> createInvestment() async {
    MessagesUtils.showLoading();
    final returnPercentage =
        Utils.parseControllerText(investmentReturnController.text);
    final db = FirebaseFirestore.instance;
    final investmentData = {
      'created_by': db.collection('users').doc(Utils.getUser().id),
      'name': investmentNameController.text,
      'minimum_investment': Utils.parseControllerText(minAmountController.text),
      'maximum_investment': Utils.parseControllerText(maxAmountController.text),
      'return_percentage': returnPercentage,
      'created_at': Timestamp.fromDate(DateTime.now()),
      'initial_date': Timestamp.fromDate(beginDate.value),
      'end_date': Timestamp.fromDate(endDate.value),
      'is_available': isAvailable.value,
    };
    final params = FirebaseParamsRequest(
      collection: 'investments',
      documentReference: investment == null
          ? null
          : db.collection('investments').doc(investment!.id),
      data: investmentData,
    );
    final result = await GeneralUsecase(apiRepository).writeData(params);
    MessagesUtils.dismissLoading();
    result.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: createInvestment),
      (r) {
        investmentData.addAll({'id': r});

        // Enviando notificación
        if (isAvailable.value && investment == null) {
          NotificationUsecase().sendNotificationToTopic(
            '¡Nueva inversión disponible!',
            'Descubre nuestra última oportunidad de inversión con una rentabilidad del ${Constants.decimalFormat.format(returnPercentage)}%.',
            AvailableTopic.allClients.name,
          );
        }

        final isEditing = investment != null;
        final investmentResult = Investment.fromJson(investmentData);
        if (isEditing) {
          final investmentController = Get.find<AdminInvestmentsController>();
          // final indexToReplace = bankController.banks.indexOf(bank);
          final indexToReplace = investmentController.investments.indexWhere(
            (element) => element.id == investment!.id,
          );
          investmentController.investments.removeAt(indexToReplace);
          investmentController.investments
              .insert(indexToReplace, investmentResult);
          investmentController.refresh();
        } else {
          Get.find<AdminInvestmentsController>()
              .investments
              .insert(0, investmentResult);
        }

        Get.back();
        MessagesUtils.successSnackbar(
          'Inversión ${isEditing ? 'Editada' : 'Creada'}',
          'La inversión ha sido ${isEditing ? 'editada' : 'creada'} con éxito.',
        );
      },
    );
  }
}
