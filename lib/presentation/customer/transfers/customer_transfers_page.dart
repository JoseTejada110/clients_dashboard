import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/presentation/customer/transfers/customer_transfers_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class CustomerTransfersPage extends StatelessWidget {
  const CustomerTransfersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CustomerTransfersController(apiRepository: Get.find()),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mover Fondos'),
        actions: const [
          SupportButton(),
          UserMenuButton(),
        ],
      ),
      body: CustomCard(
        padding: Constants.bodyPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text(
                'Depositar Fondos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text(
                '¡Deposita fondos a tu cuenta e inicia a invertir ahora!',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.createTransfer),
            ),
            const Divider(),
            ListTile(
              title: const Text(
                'Retirar Fondos',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: const Text('Realizar solicitud de retiro de efectivo.'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Get.toNamed(AppRoutes.createTransfer),
            ),
          ],
        ),
      ),
    );
  }
}