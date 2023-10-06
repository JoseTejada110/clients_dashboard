import 'package:get/instance_manager.dart';
import 'package:bisonte_app/presentation/banks/create/create_bank_controller.dart';

class CreateBankBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateBankController(apiRepository: Get.find()),
    );
  }
}
