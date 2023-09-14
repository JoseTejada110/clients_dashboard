import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/profile/profile_controller.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ProfileController(apiRepository: Get.find()),
    );
  }
}
