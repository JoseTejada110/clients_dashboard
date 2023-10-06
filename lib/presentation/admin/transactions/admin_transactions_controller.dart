import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/data/models/app_transaction_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class AdminTransactionsController extends GetxController with StateMixin {
  AdminTransactionsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadTransactions();
    super.onInit();
  }

  RxList<AppTransaction> transactions = <AppTransaction>[].obs;

  Future<void> loadTransactions() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'transactions',
      parser: AppTransaction.fromJson,
      orderBy: FirebaseOrderByParam('date', descending: true),
    );
    final result =
        await GeneralUsecase(apiRepository).readData<AppTransaction>(params);
    result.fold(
      (failure) => change(
        null,
        status: RxStatus.error(getMessageFromFailure(failure).toString()),
      ),
      (r) {
        transactions.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  final TextEditingController searchController = TextEditingController();
}
