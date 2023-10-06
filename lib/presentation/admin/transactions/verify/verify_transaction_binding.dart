import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/admin/transactions/verify/verify_transaction_controller.dart';

class VerifyTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => VerifyTransactionController(apiRepository: Get.find()),
    );
  }
}
