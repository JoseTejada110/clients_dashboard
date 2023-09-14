import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/customer/investments/customer_investments_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/investments_list.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class CustomerInvestmentsPage extends StatelessWidget {
  const CustomerInvestmentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CustomerInvestmentsController(apiRepository: Get.find()),
    );
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
        body: CustomCard(
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
                    isFromCustomerView: true,
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
