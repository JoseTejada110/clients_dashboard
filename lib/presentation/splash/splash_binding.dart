import 'package:get/get.dart';
import 'package:bisonte_app/presentation/splash/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => SplashController(localStorageRepository: Get.find()),
    );
  }
}
