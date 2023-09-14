import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';

class SplashController extends GetxController {
  SplashController({required this.localStorageRepository});
  final LocalStorageRepositoryInterface localStorageRepository;

  @override
  void onInit() async {
    await _loadLanguage();
    // Get.offAllNamed(AppRoutes.login);
    super.onInit();
  }

  Future<void> _loadLanguage() async {
    final currentLanguage = await localStorageRepository.getCurrentLanguage();
    if (currentLanguage != null) {
      final locale = Locale(currentLanguage, 'US');
      Get.updateLocale(locale);
    }
  }
}
