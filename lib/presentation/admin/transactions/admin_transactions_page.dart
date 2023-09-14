import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/instance_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/transactions/admin_transactions_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/transactions_list.dart';
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
                    // Padding(
                    //   padding: Constants.bodyPadding,
                    //   child: CustomInput(
                    //     controller: controller.searchController,
                    //     prefixIcon: const Icon(Icons.search),
                    //     hintText: 'Buscar Transacciones',
                    //   ),
                    // ),
                    Expanded(
                      child: controller.obx(
                          onError: (error) => ErrorPlaceholder(
                                error ?? '',
                                tryAgain: controller.loadTransactions,
                              ),
                          onLoading: const LoadingWidget(), (_) {
                        return TransactionsList(
                          onRefresh: controller.loadTransactions,
                          transactions: controller.transactions,
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
