import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeleton_app/domain/entities/menu_item_class.dart';

class UploadFileButton extends StatelessWidget {
  const UploadFileButton({
    super.key,
    required this.onImagePicked,
    this.customTitle,
  });
  final void Function(File image) onImagePicked;
  final String? customTitle;

  @override
  Widget build(BuildContext context) {
    final items = [
      MenuItemClass(title: 'Galería', icon: Icons.photo_library_outlined),
      MenuItemClass(title: 'Cámara', icon: Icons.camera_alt_outlined),
    ];
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return ElevatedButton.icon(
          icon: const Icon(Icons.file_upload_outlined),
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          label: Text(customTitle ?? 'Cargar'),
        );
      },
      menuChildren: items
          .map(
            (element) => MenuItemButton(
              trailingIcon: Icon(
                element.icon,
                color: Theme.of(context).textTheme.titleMedium?.color,
              ),
              child: Text(
                element.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onPressed: () async {
                final ImagePicker picker = ImagePicker();
                final source = element.title == 'Galería'
                    ? ImageSource.gallery
                    : ImageSource.camera;
                final XFile? image = await picker.pickImage(
                  source: source,
                  maxHeight: 640,
                  maxWidth: 640,
                );
                if (image == null) return;
                onImagePicked(File(image.path));
              },
            ),
          )
          .toList(),
    );
  }
}
