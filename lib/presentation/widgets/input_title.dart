import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/constants.dart';

class InputTitle extends StatelessWidget {
  const InputTitle(
    this.title, {
    super.key,
    this.bottomPadding = const EdgeInsets.only(bottom: 8.0),
    this.isRequired = false,
  });
  final String title;
  final EdgeInsetsGeometry bottomPadding;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: bottomPadding,
      child: RichText(
        text: TextSpan(
          text: title,
          style: Get.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          children: isRequired
              ? [
                  TextSpan(text: ' *', style: TextStyle(color: Constants.red)),
                ]
              : [],
        ),
      ),
      // child: Text(
      //   title,
      //   style: Get.theme.textTheme.titleMedium?.copyWith(
      //     fontWeight: FontWeight.bold,
      //   ),
      // ),
    );
  }
}
