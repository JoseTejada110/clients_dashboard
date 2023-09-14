import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/investment_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';
import 'package:skeleton_app/presentation/admin/investments/admin_investments_controller.dart';

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
    // TODO: Editar cuando corresponda
    MessagesUtils.showLoading();
    final newInvestment = Investment(
      id: '',
      createdBy: FirebaseFirestore.instance
          .collection('users')
          .doc(Utils.getUser().id),
      name: investmentNameController.text,
      minimumInvestment: Utils.parseControllerText(minAmountController.text),
      maximumInvestment: Utils.parseControllerText(maxAmountController.text),
      returnPercentage:
          Utils.parseControllerText(investmentReturnController.text),
      createdAt: DateTime.now(),
      initialDate: beginDate.value,
      endDate: endDate.value,
      isAvailable: isAvailable.value,
    );
    final params = FirebaseParamsRequest(
      collection: 'investments',
      data: newInvestment.toJson(),
    );
    final result = await GeneralUsecase(apiRepository).writeData(params);
    MessagesUtils.dismissLoading();
    result.fold(
      (l) {
        print('l: $l');
        MessagesUtils.errorDialog(l, tryAgain: createInvestment);
      },
      (r) {
        // TODO: NOTIFICAR A TODOS LOS USUARIOS!
        print('r: $r');
        MessagesUtils.successSnackbar(
          'Inversión Creada',
          'La inversión ha sido creada con éxito.',
        );
        newInvestment.id = r;
        Get.find<AdminInvestmentsController>().investments.add(newInvestment);
        resetForm();
      },
    );
  }

  void resetForm() {
    investmentNameController.clear();
    investmentReturnController.clear();
    minAmountController.text = '1.00';
    maxAmountController.text = '1.00';
    beginDate.value = DateTime.now();
    endDate.value = DateTime.now();
    isAvailable.value = true;
  }
}
