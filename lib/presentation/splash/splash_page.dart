import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton_app/data/datasource/api_repository_impl.dart';
import 'package:skeleton_app/data/datasource/local_storage_repository_impl.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/repositories/local_storage_repository.dart';
import 'package:skeleton_app/presentation/main_binding.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/splash/splash_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  Widget build(BuildContext context) {
    // Dependencies inyection
    Get.put<LocalStorageRepositoryInterface>(
      LocalStorageRepositoryImpl(),
      permanent: true,
    );
    Get.put<ApiRepositoryInteface>(
      ApiRepositoryImpl(),
      permanent: true,
    );
    _loadLanguage();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/nuac_icon.jpeg',
              height: 150,
              width: 150,
            ),
            const SizedBox(height: 15),
            const Text(
              'NuacTransfer',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 15),
            const CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadLanguage() async {
    final currentLanguage =
        await Get.find<LocalStorageRepositoryInterface>().getCurrentLanguage();
    if (currentLanguage != null) {
      final locale = Locale(currentLanguage, 'US');
      await Get.updateLocale(locale);
    }
    if (!mounted) return;
    context.go(AppRoutes.login);
  }
}
