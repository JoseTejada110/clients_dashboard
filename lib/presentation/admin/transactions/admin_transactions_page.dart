import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/transactions/admin_transactions_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/custom_listview_builder.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class AdminTransactionsPage extends StatelessWidget {
  const AdminTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminTransactionsController(apiRepository: Get.find()),
    );
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Transacciones'),
          actions: const [
            SupportButton(),
            UserMenuButton(),
          ],
        ),
        body: Column(
          children: [
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
                        hintText: 'Buscar Transacciones',
                      ),
                    ),
                    Expanded(
                      child: CustomListViewBuilder(
                        itemCount: 400,
                        itemBuilder: (BuildContext context, int index) {
                          return const _TransactionItem();
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

class _TransactionItem extends StatelessWidget {
  const _TransactionItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Depósito de fondos',
        style: TextStyle(fontWeight: FontWeight.bold),
        maxLines: 2,
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Constants.dateFormat.format(DateTime.now())),
          const Text('Crédito'),
          const Text(
            'Pendiente',
            style: TextStyle(
              color: Constants.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Text(
        NumberFormat.simpleCurrency().format(100000),
        style: const TextStyle(
          color: Constants.green,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onTap: () {
        print('GO TO TRANSACTION DETAILS');
      },
    );
  }
}
