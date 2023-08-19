import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class MessagesUtils {
  static void showLoading({String message = "Cargando..."}) {
    Get.dialog(
      Dialog(
        backgroundColor: Get.theme.indicatorColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator.adaptive(
                  backgroundColor: Colors.white,
                ),
                const SizedBox(height: 20),
                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static void dismissLoading() {
    Get.back();
  }

  static dynamic errorDialog(
    FailureEntity failure, {
    Future<void> Function()? tryAgain,
  }) {
    Get.dialog(
      DialogErrorPlaceholcer(
        message: getMessageFromFailure(failure),
        tryAgain: tryAgain,
      ),
    );
    return null;
  }

  static void successSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      icon: _buildCircleIcon(Icons.check, Colors.green),
      backgroundColor: Colors.green.withOpacity(0.3),
    );
  }

  static void errorSnackbar(String title, String message) {
    Get.snackbar(
      title,
      message,
      backgroundColor: Colors.redAccent.withOpacity(0.3),
      icon: _buildCircleIcon(Icons.close, Colors.redAccent),
      duration: const Duration(seconds: 5),
    );
  }

  static Widget _buildCircleIcon(IconData icon, Color color) {
    return Container(
      height: 20,
      width: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
      ),
      child: Icon(icon, color: Colors.white, size: 15),
    );
  }
}
