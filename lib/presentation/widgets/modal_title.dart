import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/presentation/widgets/custom_buttons.dart';

class ModalTitle extends StatelessWidget {
  const ModalTitle({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Get.theme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: const BoxDecoration(
        color: Constants.secondaryColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleLarge?.copyWith(
                color: Colors.white,
              ),
            ),
          ),
          CustomIconButton(
            constraints: const BoxConstraints(),
            padding: EdgeInsets.zero,
            tooltip: 'Cerrar',
            iconColor: Colors.white,
            icon: Icons.close,
            onPressed: () => Get.back(),
          ),
        ],
      ),
    );
  }
}
