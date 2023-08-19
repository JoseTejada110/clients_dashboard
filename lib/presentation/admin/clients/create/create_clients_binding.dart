import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/admin/clients/create/create_clients_controller.dart';

class CreateClientsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateClientsController(apiRepository: Get.find()),
    );
  }
}
