import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/instance_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/presentation/splash/splash_controller.dart';

class SplashPage extends GetView<SplashController> {
  const SplashPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.find<SplashController>();
    return const Scaffold(
      backgroundColor: Constants.darkIndicatorColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.business,
              color: Colors.white,
              size: 80,
            ),
            SizedBox(height: 15),
            Text(
              'SKELETON APP',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 30,
              ),
            ),
            SizedBox(height: 15),
            CircularProgressIndicator.adaptive(
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
