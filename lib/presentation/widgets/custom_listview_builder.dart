import 'package:flutter/material.dart';
import 'package:skeleton_app/core/constants.dart';

class CustomListViewBuilder extends StatelessWidget {
  const CustomListViewBuilder({
    super.key,
    required this.itemBuilder,
    required this.itemCount,
    this.shrinkWrap = false,
    this.padding = Constants.bodyPadding,
  });
  final Widget? Function(BuildContext, int) itemBuilder;
  final int itemCount;
  final bool shrinkWrap;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      removeBottom: true,
      child: ListView.separated(
        padding: padding,
        itemCount: itemCount,
        shrinkWrap: shrinkWrap,
        itemBuilder: itemBuilder,
        separatorBuilder: (BuildContext context, int index) => const Divider(),
      ),
    );
  }
}
