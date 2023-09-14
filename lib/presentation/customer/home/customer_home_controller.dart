import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/account_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';

class CustomerHomeController extends GetxController with StateMixin {
  CustomerHomeController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadUserInvestments();
    super.onInit();
  }

  Future<void> loadUserInvestments() async {
    change(null, status: RxStatus.loading());
    final user = Utils.getUser();
    final params = FirebaseParamsRequest(
      collection: 'user_investments',
      parser: AccountInvestment.fromJson,
      whereParams: [
        FirebaseWhereParams('is_active', isEqualTo: true),
        FirebaseWhereParams(
          'account',
          isEqualTo: FirebaseFirestore.instance
              .collection('accounts')
              .doc(user.accounts.first.id),
        ),
      ],
      orderBy: FirebaseOrderByParam('investment_date', descending: true),
    );
    final result =
        await GeneralUsecase(apiRepository).readData<AccountInvestment>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        user.accounts.first.accountInvestments = r;
        change(null, status: RxStatus.success());
      },
    );
  }
}
