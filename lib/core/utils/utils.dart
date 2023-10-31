import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/instance_manager.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/presentation/home/home_controller.dart';

import '../../data/models/user_model.dart';

class Utils {
  static void unfocus(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  static double parseControllerText(String? text) {
    return double.tryParse(
            text?.replaceAll(',', '').replaceAll('\$', '') ?? '0.0') ??
        0.0;
  }

  static void copyToClipboard(
    String text,
    String successTitle,
    String successMessage,
  ) async {
    await Clipboard.setData(ClipboardData(text: text));
    MessagesUtils.successSnackbar(successTitle, successMessage);
  }

  // static Future<void> callPhoneNumber(String data) async {
  //   try {
  //     final number = data
  //         .replaceAll('-', '')
  //         .replaceAll('(', '')
  //         .replaceAll(')', '')
  //         .trim();
  //     if (number.isEmpty) {
  //       MessagesUtils.errorSnackbar(
  //         'Número Inválido',
  //         'No hemos podido encontrar un número telefónico asociado a esta entidad.',
  //       );
  //       return;
  //     }
  //     final uri = Uri.parse('tel:+1-$number');
  // if (await canLaunchUrl(uri)) {
  //   await launchUrl(uri);
  // } else {
  //   // _failedSnackbar(context, 'Número telefónico inválido');
  // }
  // } catch (e) {
  // _failedSnackbar(context, 'No se pudo realizar la llamada');
  // }
  // }

  static bool isNumeric(String? string) {
    if (string == null) {
      return false;
    }
    return double.tryParse(string) != null;
  }

  static String getNameShortcuts(String name) {
    final splittedName = name.split(' ');
    switch (splittedName.length) {
      case 1:
        return splittedName[0][0];
      case 2:
        return splittedName[0][0] + splittedName[1][0];
      case 3:
        return splittedName[0][0] + splittedName[2][0];
      case 4:
        return splittedName[0][0] + splittedName[2][0];
    }
    return name[0];
  }

  static UserModel getUser() => Get.find<HomeController>().user;
  static DocumentReference<Map<String, dynamic>> getUserReference() =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(Get.find<HomeController>().user.id);
}
