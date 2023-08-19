import 'package:flutter/material.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';

class SupportButton extends StatelessWidget {
  const SupportButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      tooltip: 'Obtener ayuda',
      icon: Icons.help_outline,
      onPressed: () {
        //
      },
    );
  }
}
