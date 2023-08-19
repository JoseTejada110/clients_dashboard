import 'package:flutter/material.dart';
import 'package:skeleton_app/domain/entities/menu_item_class.dart';
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
            ),
          )
          .toList(),
    );
  }
}
