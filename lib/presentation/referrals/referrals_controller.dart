import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/referral_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';

class ReferralsController extends GetxController with StateMixin {
  ReferralsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadReferrals();
    super.onInit();
  }

  Future<void> loadReferrals() async {
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'referrals',
      parser: Referral.fromJson,
      whereParams: [
        FirebaseWhereParams('referred_by', isEqualTo: Utils.getUserReference()),
      ],
    );
    final result =
        await GeneralUsecase(apiRepository).readData<Referral>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        referrals.value = r;
        change(null, status: RxStatus.success());
      },
    );
  }

  RxList<Referral> referrals = <Referral>[].obs;
}
