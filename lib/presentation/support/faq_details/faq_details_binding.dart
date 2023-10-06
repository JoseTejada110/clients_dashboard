import 'package:get/get.dart';
import 'package:bisonte_app/presentation/support/faq_details/faq_details_controller.dart';

class FaqDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => FaqDetailsController(apiRepository: Get.find()),
    );
  }
}
