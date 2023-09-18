import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/profile/profile_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Utils.getUser();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomCard(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Constants.indicatorColor,
                // backgroundColor: Color(0XFFB8860B),
                child: Text(
                  Utils.getNameShortcuts(user.name),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.status,
                    style: TextStyle(
                      color: user.getColorByStatus(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.copy),
                    label: const Text('Copiar código de referido'),
                    onPressed: () => Utils.copyToClipboard(
                      user.id,
                      'Código Copiado',
                      'Código de referido copiado al portapapeles.',
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                print('GO TO CLIENT DETAILS');
              },
            ),
          ),
          const SizedBox(height: 10),
          CustomCard(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: const Icon(Icons.business),
                    title: const Text(
                      'Administrar mis cuentas de banco',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.banks),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.people),
                    title: const Text(
                      'Ver mis referidos',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => Get.toNamed(AppRoutes.referrals),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
