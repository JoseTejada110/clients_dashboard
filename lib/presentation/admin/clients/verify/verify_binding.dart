import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/admin/clients/verify/verify_client_controller.dart';

class VerifyClientBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => VerifyClientController(apiRepository: Get.find()),
    );
  }
}
