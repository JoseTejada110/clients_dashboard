import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_date_picker.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';

class CreateInvestmentsPage extends GetView<CreateInvestmentsController> {
  const CreateInvestmentsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Inversión'),
        ),
        body: CustomCard(
          child: ListView(
            padding: Constants.bodyPadding,
            physics: const ClampingScrollPhysics(),
            children: [
              const InputTitle('Nombre de la inversión', isRequired: true),
              CustomInput(
                controller: controller.investmentNameController,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              const InputTitle('Porciento de retorno', isRequired: true),
              NumericInput(
                controller: controller.investmentReturnController,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InputTitle('Fecha Inicio', isRequired: true),
                        Obx(() {
                          return CustomDatePicker(
                            initialDateTime: controller.beginDate.value,
                            value: controller.beginDate.value,
                            onDatePicked: controller.pickBeginDate,
                          );
                        }),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InputTitle('Fecha Fin', isRequired: true),
                        Obx(() {
                          return CustomDatePicker(
                            initialDateTime: controller.endDate.value,
                            value: controller.endDate.value,
                            onDatePicked: controller.pickEndDate,
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InputTitle('Inversión Mínima', isRequired: true),
                        NumericInput(
                          controller: controller.minAmountController,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const InputTitle('Inversión Máxima', isRequired: true),
                        NumericInput(
                          controller: controller.maxAmountController,
                          inputAction: TextInputAction.done,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                return CustomCheckboxListTile(
                  value: controller.isAvailable.value,
                  onChanged: controller.switchIsAvailable,
                  title: '¿Está disponible?',
                );
              }),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: controller.createInvestment,
                  child: const Text('Crear Inversión'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
