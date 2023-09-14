import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class MessagesUtils {
  static void showLoading({String message = "Cargando..."}) {
    Get.dialog(
      Dialog(
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
                  style: const TextStyle(color: Colors.white),
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

  static void successSnackbar(String title, String message,
      {duration = const Duration(seconds: 5)}) {
    Get.snackbar(
      title,
      message,
      icon: _buildCircleIcon(Icons.check, Colors.green),
      backgroundColor: Constants.green,
      duration: duration,
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

  //SHOW CONFIRMATION (MUESTRA UN DIÁLOGO PARA CONFIRMAT AL USUARIO)
  static Future showConfirmation({
    required BuildContext context,
    required String title,
    required Widget subtitle,
    required void Function() onConfirm,
    required void Function() onCancel,
    String confirmString = 'Sí',
    String cancelString = 'No',
    Color? confirmColor,
    Color cancelColor = Colors.grey,
  }) async {
    if (Platform.isIOS) {
      return await showCupertinoDialog(
          context: context,
          builder: (_) => CupertinoAlertDialog(
                title: Text(title),
                content: subtitle,
                actions: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: onCancel,
                      child: Text(
                        cancelString,
                        style: TextStyle(
                          color: cancelColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: CupertinoDialogAction(
                      isDefaultAction: true,
                      onPressed: onConfirm,
                      child: Text(
                        confirmString,
                        style: TextStyle(
                          color: confirmColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  )
                ],
              ));
    }
    await Get.dialog(
      AlertDialog(
        title: Text(title),
        content: subtitle,
        actions: [
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              onPressed: onCancel,
              child: Text(
                cancelString,
                style: TextStyle(
                  color: cancelColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: ElevatedButton(
              onPressed: onConfirm,
              child: Text(
                confirmString,
                style: TextStyle(
                  color: confirmColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
