import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 25,
    this.constraints,
    this.padding = const EdgeInsets.all(8.0),
    this.iconColor,
  });
  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;
  final BoxConstraints? constraints;
  final EdgeInsetsGeometry padding;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      constraints: constraints,
      padding: padding,
      tooltip: tooltip,
      color: iconColor ?? Theme.of(context).primaryColor,
      iconSize: iconSize,
      splashRadius: 20,
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}

class CustomBottomButton extends StatelessWidget {
  const CustomBottomButton({
    super.key,
    required this.title,
    this.titleColor,
    this.backgroundColor,
    required this.onTap,
    this.borderRadius = BorderRadius.zero,
  });
  final String title;
  final Color? titleColor;
  final Color? backgroundColor;
  final VoidCallback onTap;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: borderRadius,
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor ?? Get.theme.indicatorColor,
          borderRadius: borderRadius,
        ),
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Text(
            title,
            style: TextStyle(
              color: titleColor ?? Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}

class CustomFormButton extends StatelessWidget {
  const CustomFormButton({
    super.key,
    required this.title,
    required this.buttonTitle,
    required this.onPressed,
  });
  final String title;
  final String buttonTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: Get.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        CustomCard(
          onPressed: onPressed,
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  buttonTitle,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16,
                    color: title.toLowerCase().contains('seleccion')
                        ? Get.textTheme.bodySmall?.color
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomTextButton extends StatelessWidget {
  const CustomTextButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.foregroundColor,
    this.alignment = Alignment.centerLeft,
  });
  final String title;
  final VoidCallback onPressed;
  final Color? foregroundColor;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        alignment: alignment,
        foregroundColor: foregroundColor,
      ),
      onPressed: onPressed,
      child: Text(title),
    );
  }
}
