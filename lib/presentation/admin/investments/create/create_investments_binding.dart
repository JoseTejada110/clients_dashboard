import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_controller.dart';

class CreateInvestmentsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => CreateInvestmentsController(apiRepository: Get.find()),
    );
  }
}
