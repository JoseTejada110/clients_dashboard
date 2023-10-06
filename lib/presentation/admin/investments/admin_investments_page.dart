import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/instance_manager.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/presentation/admin/investments/admin_investments_controller.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/custom_input.dart';
import 'package:bisonte_app/presentation/widgets/investments_list.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';
import 'package:bisonte_app/presentation/widgets/support_button.dart';
import 'package:bisonte_app/presentation/widgets/user_menu_button.dart';

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
                      child: controller.obx(
                          onError: (error) => ErrorPlaceholder(
                                error ?? '',
                                tryAgain: controller.loadInvestments,
                              ),
                          onLoading: const LoadingWidget(), (_) {
                        return InvestmentsList(
                          onRefresh: controller.loadInvestments,
                          investments: controller.investments,
                        );
                      }),
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
