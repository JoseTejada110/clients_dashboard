import 'package:get/instance_manager.dart';
import 'package:skeleton_app/presentation/admin/bulk_notification/bulk_notification_controller.dart';

class BulkNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => BulkNotificationController(apiRepository: Get.find()),
    );
  }
}
