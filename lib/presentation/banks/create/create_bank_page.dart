import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/presentation/banks/create/create_bank_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_buttons.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/custom_dropdown.dart';
import 'package:bisonte_app/presentation/widgets/custom_input.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';

class CreateBankPage extends GetView<CreateBankController> {
  const CreateBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isEditing = controller.bank != null;
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("${isEditing ? 'Editar' : 'Crear'} Cuenta de Banco"),
        ),
        body: CustomCard(
          child: ListView(
            padding: Constants.bodyPadding,
            physics: const ClampingScrollPhysics(),
            children: [
              const InputTitle('Nombre del Banco', isRequired: true),
              CustomInput(
                controller: controller.bankNameController,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              const InputTitle('Número de Cuenta', isRequired: true),
              CustomInput(
                controller: controller.accountNumberController,
              ),
              const SizedBox(height: 10),
              const InputTitle('Tipo de Cuenta', isRequired: true),
              Obx(() {
                return CustomDropdown(
                  items: controller.accountTypes,
                  value: controller.selectedAccountType.value,
                  onChanged: controller.pickAccountType,
                );
              }),
              const SizedBox(height: 10),
              Obx(() {
                return CustomCheckboxListTile(
                  value: controller.isBusinessAccount.value,
                  onChanged: controller.switchIsBusinessAccount,
                  title: '¿Es una cuenta empresarial?',
                );
              }),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.createBank,
                  child: Text(
                    '${isEditing ? 'Editar' : 'Crear'} Cuenta de Banco',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
