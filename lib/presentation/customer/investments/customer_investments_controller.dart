import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/data/models/investment_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class CustomerInvestmentsController extends GetxController with StateMixin {
  CustomerInvestmentsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadInvestments();
    super.onInit();
  }

  Future<void> loadInvestments() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'investments',
      parser: Investment.fromJson,
      whereParams: [Filter('is_available', isEqualTo: true)],
    );
    final result =
        await GeneralUsecase(apiRepository).readData<Investment>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        investments.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  RxList<Investment> investments = <Investment>[].obs;
  final searchController = TextEditingController();
}
