import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/presentation/admin/transactions/verify/verify_transaction_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/image_picker_container.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class VerifyTransactionPage extends GetView<VerifyTransactionController> {
  const VerifyTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Procesar Transacción'),
      ),
      body: controller.obx(
        onError: (error) => ErrorPlaceholder(
          error ?? '',
          tryAgain: controller.loadUser,
        ),
        onLoading: const LoadingWidget(),
        (_) => ListView(
          physics: const ClampingScrollPhysics(),
          padding: Constants.bodyPadding,
          children: [
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      controller.customer.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(controller.customer.identification),
                    trailing: CustomIconButton(
                      tooltip: 'Llamar Cliente',
                      icon: Icons.call,
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            CustomCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Text(
                      controller.transaction.concept,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Constants.dateFormat
                              .format(controller.transaction.date),
                        ),
                        Text(
                          controller.transaction.status,
                          style: TextStyle(
                            color: controller.transaction.getStatusColor(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${controller.transaction.bankAccountName} (${controller.transaction.bankAccountNumber})',
                        ),
                      ],
                    ),
                    trailing: Text(
                      NumberFormat.simpleCurrency()
                          .format(controller.transaction.amount),
                      style: TextStyle(
                        color: controller.transaction.getTypeColor(),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  controller.transaction.voucherImage.isEmpty
                      ? const SizedBox()
                      : const Divider(),
                  controller.transaction.voucherImage.isEmpty
                      ? const SizedBox()
                      : Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 10,
                          ),
                          child: ImageContainer(
                            child: Image.network(
                              controller.transaction.voucherImage,
                              frameBuilder: (_, child, __, ___) => child,
                              loadingBuilder:
                                  (context, child, loadingProgress) =>
                                      loadingProgress == null
                                          ? child
                                          : const LoadingWidget(),
                            ),
                          ),
                        ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: controller.transaction.status == 'Procesada'
                            ? null
                            : controller.processTransaction,
                        child: const Text('Procesar Transacción'),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
