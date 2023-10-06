import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/account_model.dart';
import 'package:bisonte_app/data/models/user_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class AdminDashboardController extends GetxController with StateMixin {
  AdminDashboardController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadDashboardData();
    super.onInit();
  }

  Future<void> loadDashboardData() async {
    change(null, status: RxStatus.loading());
    final res = await GeneralUsecase(apiRepository)
        .executeFirebaseQueries<bool>(_queries);
    res.fold(
      (l) => change(
        null,
        status: RxStatus.error(getMessageFromFailure(l).toString()),
      ),
      (r) => change(null, status: RxStatus.success()),
    );
  }

  Future<bool> _queries() async {
    try {
      final db = FirebaseFirestore.instance;
      final pendingTransactionsFuture = db
          .collection('transactions')
          .where('status', isEqualTo: 'Pendiente')
          .count()
          .get();
      final pendingClientsFuture = db
          .collection('users')
          .where('status', isEqualTo: 'No Verificado')
          .count()
          .get();
      final availableInvestmentsFuture = db
          .collection('investments')
          .where('is_available', isEqualTo: true)
          .count()
          .get();
      final accountFuture =
          db.collection('accounts').doc(user.accounts.first.id).get();

      final values = await Future.wait([
        pendingTransactionsFuture,
        pendingClientsFuture,
        availableInvestmentsFuture,
        accountFuture,
      ]);
      pendingTransactions = (values[0] as AggregateQuerySnapshot).count;
      pendingClients = (values[1] as AggregateQuerySnapshot).count;
      availableInvestments = (values[2] as AggregateQuerySnapshot).count;
      final accountData = values[3] as DocumentSnapshot<Map<String, dynamic>>;
      user.accounts.first =
          Account.fromJson(accountData.data()!..addAll({'id': accountData.id}));
      investedVolume = user.accounts.first.investedAmount;
      return true;
    } catch (e) {
      return false;
    }
  }

  UserModel user = Utils.getUser();
  int pendingTransactions = 0;
  int pendingClients = 0;
  int availableInvestments = 0;
  double investedVolume = 0.0;
}
