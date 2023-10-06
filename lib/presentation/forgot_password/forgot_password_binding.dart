import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/forgot_password/forgot_password_controller.dart';

class ForgotPasswordBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ForgotPasswordController(apiRepository: Get.find()),
    );
  }
}
