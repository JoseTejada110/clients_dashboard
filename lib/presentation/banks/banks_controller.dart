import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/bank_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class BanksController extends GetxController with StateMixin {
  BanksController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadBanks();
    super.onInit();
  }

  Future<void> loadBanks() async {
    change(null, status: RxStatus.loading());
    final user = Utils.getUser();
    if (user.bankAccounts?.path == null) {
      change(null, status: RxStatus.success());
      return;
    }
    final params = FirebaseParamsRequest(
      collection: user.bankAccounts!.path,
      parser: Bank.fromJson,
    );
    final result = await GeneralUsecase(apiRepository).readData<Bank>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        banks.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  RxList<Bank> banks = <Bank>[].obs;
}
