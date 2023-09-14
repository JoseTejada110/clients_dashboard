import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/customer/transfers/transactions/customer_transactions_controller.dart';

class CustomerTransactionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CustomerTransactionsController(apiRepository: Get.find()),
    );
  }
}
