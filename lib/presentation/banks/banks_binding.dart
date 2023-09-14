import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/banks/banks_controller.dart';

class BanksBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BanksController(apiRepository: Get.find()),
    );
  }
}
