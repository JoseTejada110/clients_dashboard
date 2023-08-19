import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/customer/investments/details/investments_details_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';

class InvestmentDetailsPage extends GetView<InvestmentDetailsController> {
  const InvestmentDetailsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Invertir'),
        ),
        body: Column(
          children: [
            CustomCard(
              padding: Constants.bodyPadding,
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'Desarrollo de inmuebles Las Terrenas',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${Constants.dateFormat.format(DateTime.now())} - ${Constants.dateFormat.format(DateTime.now().add(const Duration(days: 365)))}',
                ),
                trailing: Text(
                  '${Constants.decimalFormat.format(12.59)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: CustomCard(
                padding: Constants.bodyPadding,
                child: SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const InputTitle('Plazo'),
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: const BoxDecoration(
                          color: Constants.secondaryColor,
                        ),
                        child: Text(
                          '${DateTime.now().add(const Duration(days: 365)).difference(DateTime.now()).inDays ~/ 30} meses',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InputTitle('Monto a invertir', isRequired: true),
                      NumericInput(
                        controller: controller.investmentAmountController,
                        suffixIcon: CustomTextButton(
                          title: 'Máximo',
                          onPressed: controller.setAvailableBalance,
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          text: ' Saldo disponible: ',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Colors.grey,
                                  ),
                          children: [
                            TextSpan(
                              text: NumberFormat.simpleCurrency().format(1000),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 40),
                      const InputTitle('Resumen'),
                      _buildSummaryRow(
                        'Capital invertido:',
                        NumberFormat.simpleCurrency().format(
                          Utils.parseControllerText(
                              controller.investmentAmountController.text),
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildSummaryRow(
                        'Ganancias estimadas:',
                        NumberFormat.simpleCurrency().format(
                          Utils.parseControllerText(
                                  controller.investmentAmountController.text) *
                              0.1259,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            CustomCard(
              padding: Constants.bodyPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Obx(
                        () {
                          return Checkbox.adaptive(
                            visualDensity: VisualDensity.compact,
                            activeColor: Constants.darkIndicatorColor,
                            value: controller.isTermsAccepted.value,
                            onChanged: controller.updateIsTermsAccepted,
                          );
                        },
                      ),
                      Expanded(
                        child: RichText(
                          text: TextSpan(
                            text: 'He leído y acepto el ',
                            children: [
                              TextSpan(
                                text:
                                    'Acuerdo de servicio de inversión de la empresa',
                                style: const TextStyle(
                                  color: Constants.darkIndicatorColor,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    print('SHOW TERMS AND CONDITIONS');
                                  },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () {},
                      child: const Text('Confirmar'),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String data) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.end,
            style: const TextStyle(
              color: Constants.green,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }
}
