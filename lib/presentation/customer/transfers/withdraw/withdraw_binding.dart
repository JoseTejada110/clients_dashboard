import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/customer/transfers/withdraw/withdraw_controller.dart';

class WithdrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => WithdrawController(apiRepository: Get.find()),
    );
  }
}
