import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class CreateInvestmentsController extends GetxController {
  CreateInvestmentsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  //
  final investmentNameController = TextEditingController();
  final investmentReturnController = TextEditingController();
  final minAmountController = TextEditingController(text: '1.00');
  final maxAmountController = TextEditingController(text: '1.00');
  final beginDate = DateTime.now().obs;
  final endDate = DateTime.now().obs;

  void pickBeginDate(DateTime value) => beginDate.value = value;
  void pickEndDate(DateTime value) => endDate.value = value;
}
