import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/referrals/referrals_controller.dart';

class ReferralsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ReferralsController(apiRepository: Get.find()),
    );
  }
}
