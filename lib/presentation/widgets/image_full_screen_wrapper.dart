import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/constants.dart';

class ImageFullScreenWrapperWidget extends StatelessWidget {
  const ImageFullScreenWrapperWidget({super.key, required this.child});
  final Image child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => _FullScreenPage(child: child));
      },
      child: child,
    );
  }
}

class _FullScreenPage extends StatelessWidget {
  const _FullScreenPage({
    required this.child,
  });

  final Image child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 333),
                curve: Curves.fastOutSlowIn,
                top: 80,
                bottom: 80,
                left: 0,
                right: 0,
                child: InteractiveViewer(
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4,
                  child: child,
                ),
              ),
            ],
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: MaterialButton(
                padding: const EdgeInsets.all(15),
                elevation: 0,
                // color: widget.dark ? Colors.black12 : Colors.white70,
                highlightElevation: 0,
                minWidth: double.minPositive,
                height: double.minPositive,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100),
                ),
                onPressed: () => Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back,
                  color: Constants.darkIndicatorColor,
                  size: 30,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
