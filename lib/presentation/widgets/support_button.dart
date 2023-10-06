import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';
import 'package:bisonte_app/presentation/widgets/custom_buttons.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      tooltip: 'Obtener ayuda',
      icon: Icons.help_outline,
      onPressed: () => Get.toNamed(AppRoutes.support),
    );
  }
}
