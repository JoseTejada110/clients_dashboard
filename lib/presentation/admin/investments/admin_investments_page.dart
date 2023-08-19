import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/instance_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/investments/admin_investments_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class AdminInvestmentsPage extends StatelessWidget {
  const AdminInvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminInvestmentsController(apiRepository: Get.find()),
    );
    final primaryColor = Theme.of(context).primaryColor;
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Inversiones'),
          actions: const [
            SupportButton(),
            UserMenuButton(),
          ],
        ),
        body: Column(
          children: [
            CustomCard(
              onPressed: () => Get.toNamed(AppRoutes.createInvestment),
              child: ListTile(
                leading: Icon(
                  Icons.currency_exchange,
                  color: primaryColor,
                ),
                title: const Text(
                  'Agregar Inversión',
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
                        hintText: 'Buscar Inversiones',
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: 4,
                        itemBuilder: (BuildContext context, int index) {
                          return const _InvestmentItem();
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

class _InvestmentItem extends StatelessWidget {
  const _InvestmentItem();

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: const Text(
        'Extracción de metales preciosos',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: RichText(
        text: TextSpan(
          text: '${Constants.decimalFormat.format(15.59)}% ',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.green,
            fontSize: 15,
          ),
          children: [
            TextSpan(
              text: '(12 Meses)',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 14,
                  ),
            ),
          ],
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        print('GO TO INVESTMENT DETAILS');
      },
    );
  }
}
