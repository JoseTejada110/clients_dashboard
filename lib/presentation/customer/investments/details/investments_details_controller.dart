import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class InvestmentDetailsController extends GetxController {
  InvestmentDetailsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  //
  final investmentAmountController = TextEditingController();
  final isTermsAccepted = false.obs;

  void updateIsTermsAccepted(bool? val) => isTermsAccepted.value = val ?? false;

  void setAvailableBalance() {
    investmentAmountController.text = Constants.decimalFormat.format(1000);
  }
}
