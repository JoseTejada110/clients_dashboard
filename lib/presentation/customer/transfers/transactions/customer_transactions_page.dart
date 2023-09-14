import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/customer/transfers/transactions/customer_transactions_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';
import 'package:skeleton_app/presentation/widgets/transactions_list.dart';

class CustomerTransactionsPage extends GetView<CustomerTransactionsController> {
  const CustomerTransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mis Transacciones'),
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
