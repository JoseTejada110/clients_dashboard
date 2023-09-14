import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/presentation/admin/clients/admin_clients_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class AdminClientsPage extends StatelessWidget {
  const AdminClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminClientsController(apiRepository: Get.find()),
    );
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Clientes'),
          actions: const [
            SupportButton(),
            UserMenuButton(),
          ],
        ),
        body: CustomCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: Constants.bodyPadding,
                child: CustomInput(
                  controller: controller.searchController,
                  prefixIcon: const Icon(Icons.search),
                  hintText: 'Buscar Clientes',
                ),
              ),
              Expanded(
                child: controller.obx(
                    onError: (error) => ErrorPlaceholder(
                          error ?? '',
                          tryAgain: controller.loadClients,
                        ),
                    onLoading: const LoadingWidget(), (_) {
                  return RefreshIndicator(
                    onRefresh: controller.loadClients,
                    child: ListView.builder(
                      itemCount: controller.users.length,
                      itemBuilder: (BuildContext context, int index) {
                        return _ClientItem(
                          client: controller.users[index],
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ClientItem extends StatelessWidget {
  const _ClientItem({
    required this.client,
  });
  final UserModel client;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      leading: CircleAvatar(
        backgroundColor: Constants.indicatorColor,
        child: Text(
          Utils.getNameShortcuts(client.name),
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      title: Text(
        client.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(client.identification),
          Text(
            client.status,
            style: TextStyle(
              color: client.getColorByStatus(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Get.toNamed(AppRoutes.verifyClient, arguments: client),
    );
  }
}
