import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/bank_model.dart';
import 'package:skeleton_app/presentation/customer/transfers/deposit_funds/deposit_funds_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_dropdown.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/image_picker_container.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class DepositFundsPage extends GetView<DepositFundsController> {
  const DepositFundsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Depositar Fondos'),
        ),
        body: controller.obx(
          onError: (error) => ErrorPlaceholder(
            error ?? '',
            tryAgain: controller.loadInitialData,
          ),
          onLoading: const LoadingWidget(),
          (_) => ListView(
            padding: EdgeInsets.zero,
            physics: const ClampingScrollPhysics(),
            children: [
              const CustomCard(
                padding: Constants.bodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputTitle('Antes de transferir'),
                    Text(
                      'Ten en cuenta lo siguiente antes de enviar una transferencia bancaria:',
                    ),
                    Text(
                      '1) No se aceptan transferencias bancarias de "terceros". Esto significa que los nombres en ambas cuentas deben ser iguales.',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomCard(
                padding: Constants.bodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InputTitle('Instrucciones'),
                    const Text(
                      'Para financiar tu cuenta necesitarás iniciar la transferencia bancaria en tu banco u otra institución financiera utilizando la siguiente información.',
                    ),
                    const SizedBox(height: 5),
                    _buildRichText(
                      'Banco: ',
                      controller.bankData?['bank_name'] ?? '',
                    ),
                    _buildRichText(
                      'Dirección: ',
                      controller.bankData?['address'] ?? '',
                    ),
                    _buildRichText(
                      'ABA Routing number: ',
                      controller.bankData?['routing_number'] ?? '',
                      onTap: () => Utils.copyToClipboard(
                        controller.bankData?['routing_number'] ?? '',
                        'Routing Number Copiado',
                        'Routing number copiado al portapapeles',
                      ),
                    ),
                    _buildRichText(
                      'Beneficiario: ',
                      controller.bankData?['beneficiary_name'] ?? '',
                      onTap: () => Utils.copyToClipboard(
                        controller.bankData?['beneficiary_name'] ?? '',
                        'Beneficiario Copiado',
                        'Beneficiario copiado al portapapeles',
                      ),
                    ),
                    _buildRichText(
                      'Número de cuenta del beneficiario: ',
                      controller.bankData?['account_number'] ?? '',
                      onTap: () => Utils.copyToClipboard(
                        controller.bankData?['account_number'] ?? '',
                        'Número de Cuenta Copiado',
                        'Número de cuenta copiado al portapapeles',
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              CustomCard(
                padding: Constants.bodyPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InputTitle(
                      'Cuenta de banco utilizada',
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
                    const InputTitle('Monto', isRequired: true),
                    NumericInput(controller: controller.amountController),
                    const SizedBox(height: 10),
                    const InputTitle(
                      'Imagen del comprobante',
                      isRequired: true,
                    ),
                    Obx(() {
                      return ImagePickerContainer(
                        pickedImage: controller.voucherImage.value,
                        height: 150,
                        width: 150,
                        onImagePicked: controller.pickVoucherImage,
                      );
                    }),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: () => controller.showConfirmation(context),
                        child: const Text('Realizar Depósito'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
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

  Widget _buildRichText(String title, String data, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: RichText(
              text: TextSpan(
                text: title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: onTap != null ? Constants.darkIndicatorColor : null,
                ),
                children: [
                  TextSpan(
                    text: data,
                    style: const TextStyle(fontWeight: FontWeight.normal),
                  ),
                ],
              ),
            ),
          ),
          onTap != null
              ? const Padding(
                  padding: EdgeInsets.only(left: 5),
                  child: Icon(
                    Icons.copy,
                    size: 15,
                    color: Constants.darkIndicatorColor,
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }
}
