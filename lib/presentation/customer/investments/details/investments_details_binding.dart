import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/customer/investments/details/investments_details_controller.dart';

class InvestmentDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => InvestmentDetailsController(apiRepository: Get.find()),
    );
  }
}
