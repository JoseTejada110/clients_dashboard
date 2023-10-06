import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/customer/investments/invest/invest_controller.dart';

class InvestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => InvestController(apiRepository: Get.find()),
    );
  }
}
