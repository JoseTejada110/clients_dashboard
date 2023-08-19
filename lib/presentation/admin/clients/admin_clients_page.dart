import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/clients/admin_clients_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/custom_listview_builder.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class _Client {
  _Client({
    required this.identification,
    required this.name,
    required this.verificadoString,
  });
  final String identification;
  final String name;
  final String verificadoString;
  String getNameShortcuts() {
    final splittedName = name.split(' ');
    return splittedName[0][0] + splittedName[1][0];
  }
}

class AdminClientsPage extends StatelessWidget {
  const AdminClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminClientsController(apiRepository: Get.find()),
    );
    final clients = [
      _Client(
        identification: '402-1058384-7',
        name: 'José Tejada',
        verificadoString: 'No Verificado',
      ),
      _Client(
        identification: '422-5218234-5',
        name: 'Robert Reyes',
        verificadoString: 'No Verificado',
      ),
    ];
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
        body: Column(
          children: [
            CustomCard(
              onPressed: () => Get.toNamed(AppRoutes.createClient),
              child: ListTile(
                leading: Icon(
                  Icons.group_add,
                  color: primaryColor,
                ),
                title: const Text(
                  'Agregar Cliente',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  size: 30,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CustomCard(
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
                      child: CustomListViewBuilder(
                        itemCount: clients.length,
                        itemBuilder: (BuildContext context, int index) {
                          return _ClientItem(client: clients[index]);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ClientItem extends StatelessWidget {
  const _ClientItem({required this.client});
  final _Client client;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Constants.indicatorColor,
        // backgroundColor: Color(0XFFB8860B),
        child: Text(
          client.getNameShortcuts(),
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
            client.verificadoString,
            style: const TextStyle(
              color: Constants.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        print('GO TO CLIENT DETAILS');
      },
    );
  }
}
