import 'package:get/get.dart';
import 'package:bisonte_app/presentation/support/support_controller.dart';

class SupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SupportController(apiRepository: Get.find()),
    );
  }
}
