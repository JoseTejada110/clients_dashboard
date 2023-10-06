import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/signup/signup_controller.dart';

class SignUpBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SignUpController(apiRepository: Get.find()),
    );
  }
}
