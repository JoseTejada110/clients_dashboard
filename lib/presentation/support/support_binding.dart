import 'package:get/get.dart';
import 'package:skeleton_app/presentation/support/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SupportController(apiRepository: Get.find()),
    );
  }
}
