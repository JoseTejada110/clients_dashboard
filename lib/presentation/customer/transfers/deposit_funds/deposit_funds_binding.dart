import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/customer/transfers/deposit_funds/deposit_funds_controller.dart';

class DepositFundsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => DepositFundsController(apiRepository: Get.find()),
    );
  }
}
