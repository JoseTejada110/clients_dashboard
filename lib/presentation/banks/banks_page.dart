import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/presentation/banks/banks_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class BanksPage extends GetView<BanksController> {
  const BanksPage({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Cuentas de Banco'),
      ),
      body: Column(
        children: [
          CustomCard(
            onPressed: () => Get.toNamed(AppRoutes.createBank),
            child: ListTile(
              leading: Icon(
                Icons.business,
                color: primaryColor,
              ),
              title: const Text(
                'Agregar Cuenta de Banco',
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
              child: controller.obx(
                onError: (error) => ErrorPlaceholder(
                  error ?? '',
                  tryAgain: controller.loadBanks,
                ),
                onLoading: const LoadingWidget(),
                (state) => RefreshIndicator(
                  onRefresh: controller.loadBanks,
                  child: ListView.separated(
                    itemCount: controller.banks.length,
                    itemBuilder: (context, index) {
                      final bank = controller.banks[index];
                      return ListTile(
                        title: Text(
                          '${bank.bankName} (${bank.accountNumber})',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(bank.accountType),
                            Text(
                              bank.isBusinessAccount
                                  ? '(Cuenta Empresarial)'
                                  : '(Cuenta Personal)',
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () =>
                            Get.toNamed(AppRoutes.createBank, arguments: bank),
                      );
                    },
                    separatorBuilder: (BuildContext context, int index) =>
                        const Divider(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
