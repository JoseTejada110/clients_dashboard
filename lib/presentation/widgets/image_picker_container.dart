import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_app/presentation/widgets/image_full_screen_wrapper.dart';
import 'package:skeleton_app/presentation/widgets/upload_file_button.dart';

class ImagePickerContainer extends StatelessWidget {
  const ImagePickerContainer({
    super.key,
    required this.pickedImage,
    this.height = 150,
    this.width = 150,
    required this.onImagePicked,
  });
  final File? pickedImage;
  final double height;
  final double width;
  final void Function(File) onImagePicked;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ImageContainer(
          child: pickedImage != null
              ? ImageFullScreenWrapperWidget(child: Image.file(pickedImage!))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    UploadFileButton(onImagePicked: onImagePicked),
                    const SizedBox(height: 10),
                    const Text('Formato .jpg/.jpeg/.png'),
                  ],
                ),
        ),
        pickedImage != null
            ? Padding(
                padding: const EdgeInsets.only(top: 5.0),
                child: UploadFileButton(
                  onImagePicked: onImagePicked,
                  customTitle: 'Cambiar Imagen',
                ),
              )
            : const SizedBox(),
      ],
    );
  }
}

class ImageContainer extends StatelessWidget {
  const ImageContainer({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [5, 5],
      radius: const Radius.circular(5),
      color: const Color(0XFF494d56),
      strokeWidth: 2,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 115,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0XFF2a3139),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: child,
      ),
    );
  }
}
