import 'package:flutter/material.dart';

class Utils {
  static void unfocus(BuildContext context) {
    final FocusScopeNode currentScope = FocusScope.of(context);
    if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  static double parseControllerText(String? text) {
    return double.tryParse(text?.replaceAll(',', '') ?? '0.0') ?? 0.0;
  }

  static bool isNumeric(String? string) {
    if (string == null) {
      return false;
    }
    return double.tryParse(string) != null;
  }

  // static int getUserId() => Get.find<HomeController>().usuario.idUsuario;
}
