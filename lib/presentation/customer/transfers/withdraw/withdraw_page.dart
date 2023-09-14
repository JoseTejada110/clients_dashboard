import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/bank_model.dart';
import 'package:skeleton_app/presentation/customer/transfers/withdraw/withdraw_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_dropdown.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class WithdrawPage extends GetView<WithdrawController> {
  const WithdrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Solicitar Retiro'),
        ),
        body: controller.obx(
          onError: (error) => ErrorPlaceholder(
            error ?? '',
            tryAgain: controller.loadInitialData,
          ),
          onLoading: const LoadingWidget(),
          (_) => CustomCard(
            child: ListView(
              padding: Constants.bodyPadding,
              physics: const ClampingScrollPhysics(),
              children: [
                const InputTitle(
                  'Cuenta de banco a acreditar',
                  isRequired: true,
                ),
                Row(
                  children: [
                    Obx(() {
                      return Expanded(
                        child: BankDropdown(
                          items: controller.banks,
                          value: controller.selectedBank.value,
                          onChanged: controller.pickBank,
                        ),
                      );
                    }),
                    const SizedBox(width: 10),
                    CustomIconButton(
                      tooltip: 'Crear Banco',
                      iconSize: 40,
                      icon: Icons.add_circle_outline,
                      onPressed: _navigateToCreateBank,
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const InputTitle('Monto a retirar', isRequired: true),
                NumericInput(
                  controller: controller.amountController,
                  inputAction: TextInputAction.done,
                  suffixIcon: CustomTextButton(
                    title: 'Máximo',
                    onPressed: controller.setAvailableBalance,
                  ),
                ),
                RichText(
                  text: TextSpan(
                    text: ' Saldo disponible: ',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                        ),
                    children: [
                      TextSpan(
                        text: NumberFormat.simpleCurrency().format(controller
                            .user.accounts.first
                            .getAvailableBalance()),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => controller.showConfirmation(context),
                    child: const Text('Solicitar Retiro'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToCreateBank() async {
    final createdBank = await Get.toNamed(AppRoutes.createBank);
    if (createdBank == null) return;
    controller.addBank(createdBank as Bank);
  }
}
