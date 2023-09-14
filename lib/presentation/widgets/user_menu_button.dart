import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/domain/entities/menu_item_class.dart';
import 'package:skeleton_app/presentation/home/home_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';

class UserMenuButton extends StatelessWidget {
  const UserMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      MenuItemClass(title: 'Perfil', icon: Icons.person_outline_rounded),
      MenuItemClass(title: 'Cerrar Sesión', icon: Icons.logout),
    ];
    return MenuAnchor(
      builder:
          (BuildContext context, MenuController controller, Widget? child) {
        return CustomIconButton(
          tooltip: 'Mostrar Menú',
          icon: Icons.more_horiz,
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
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
              onPressed: () {
                switch (element.title) {
                  case 'Perfil':
                    Get.toNamed(AppRoutes.profile);
                    break;
                  case 'Cerrar Sesión':
                    Get.delete<HomeController>(force: true);
                    Get.offAllNamed(AppRoutes.login);
                    break;
                }
              },
            ),
          )
          .toList(),
    );
  }
}
