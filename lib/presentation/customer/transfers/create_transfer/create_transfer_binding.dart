import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_controller.dart';

class CreateTransferBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateTransferController(apiRepository: Get.find()),
    );
  }
}
