import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/login/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => LoginController(
        apiRepository: Get.find(),
        localRepository: Get.find(),
      ),
    );
  }
}
