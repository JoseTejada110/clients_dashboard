import 'package:bisonte_app/presentation/widgets/investment_summary_row.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/presentation/customer/investments/invest/invest_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_buttons.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/custom_input.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';
import 'package:bisonte_app/presentation/widgets/modal_title.dart';

class InvestPage extends GetView<InvestController> {
  const InvestPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final investment = controller.investment!;
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
                title: Text(
                  investment.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '${Constants.dateFormat.format(investment.initialDate)} - ${Constants.dateFormat.format(investment.endDate)}',
                ),
                trailing: Text(
                  '${Constants.decimalFormat.format(investment.returnPercentage)}%',
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
                          '${investment.getMonthBetweenDates()} meses',
                        ),
                      ),
                      const SizedBox(height: 10),
                      const InputTitle('Monto a invertir', isRequired: true),
                      NumericInput(
                        controller: controller.investmentAmountController,
                        inputAction: TextInputAction.done,
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
                              text: NumberFormat.simpleCurrency().format(
                                  controller.user.accounts.first
                                      .getAvailableBalance()),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      const Divider(height: 40),
                      const InputTitle('Resumen'),
                      GetBuilder<InvestController>(
                        id: 'invested_capital',
                        builder: (InvestController controller) {
                          return InvestmentSummaryRow(
                            title: 'Capital invertido:',
                            data: NumberFormat.simpleCurrency().format(
                              Utils.parseControllerText(
                                  controller.investmentAmountController.text),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 10),
                      GetBuilder<InvestController>(
                        id: 'invested_capital',
                        builder: (InvestController controller) {
                          return InvestmentSummaryRow(
                            title: 'Ganancias estimadas:',
                            data: NumberFormat.simpleCurrency().format(
                              Utils.parseControllerText(controller
                                      .investmentAmountController.text) *
                                  (investment.returnPercentage / 100),
                            ),
                          );
                        },
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
                                    Get.dialog(
                                      const _TermsAndConditionsDialog(),
                                    );
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
                      onPressed: () => controller.showConfirmation(context),
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
}

class _TermsAndConditionsDialog extends GetView<InvestController> {
  const _TermsAndConditionsDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      backgroundColor: Constants.cardColor,
      child: Column(
        children: [
          const ModalTitle(title: 'Términos y Condiciones'),
          Expanded(
            child: Scrollbar(
              thumbVisibility: true,
              child: ListView(
                padding: Constants.bodyPadding,
                children: const [
                  Text(
                    'Términos y condiciones para la inversión del cliente en el producto de inversión de la empresaLos siguientes términos y condiciones rigen la relación entre el cliente ("Cliente") y la compañía de inversión ("Compañía") para la administración de los fondos del Cliente en el producto de inversión de la Compañía ("Producto"). Al celebrar este acuerdo, el Cliente reconoce y acepta los siguientes términos y condiciones:1. Autorización de Inversión: a. El Cliente autoriza a la Compañía a administrar e invertir los fondos del Cliente de acuerdo con la estrategia de inversión de la Compañía y dentro de las pautas establecidas por el Cliente. b. El Monto de la Inversión y cualquier depósito o retiro posterior se realizarán a discreción del Cliente y de acuerdo con las políticas y procedimientos de la Compañía.2. Riesgos: a. El cliente reconoce que todas las inversiones implican riesgos y no hay garantía de ganancias ni protección contra pérdidas. b. El Cliente acepta asumir todos los riesgos de inversión asociados con la inversión en el Producto. C. El Cliente entiende que el valor de las inversiones puede fluctuar y puede resultar en una pérdida del capital invertido.3. Estrategia y objetivos de inversión: a. La Compañía empleará su estrategia de inversión para administrar e invertir los fondos del Cliente en el Producto para lograr los objetivos de inversión establecidos. b. La Compañía proporcionará actualizaciones periódicas sobre el desempeño del Producto, incluido cualquier cambio importante en la estrategia u objetivos de inversión.4. Honorarios y Gastos: a. El Cliente acepta pagar a la Compañía las tarifas y gastos especificados para administrar los fondos del Cliente en el Producto. b. Las tarifas y gastos podrán deducirse directamente de los fondos invertidos o cobrarse por separado, según lo acordado por ambas partes.5. Informes y comunicación: a. La Compañía proporcionará informes y declaraciones periódicas al Cliente, detallando el desempeño de la inversión del Cliente en el Producto. b. La Compañía responderá con prontitud a cualquier consulta o solicitud razonable de información del Cliente con respecto a la inversión en el Producto.6. Terminación: a. Cualquiera de las partes podrá rescindir este acuerdo mediante notificación por escrito a la otra parte. b. En caso de rescisión, la Compañía liquidará la inversión del Cliente en el Producto y devolverá los fondos restantes al Cliente, menos las tarifas y gastos aplicables. El tiempo para cerrar y liquidar después de la terminación mencionada anteriormente debe ser no mayor ni menor de 30 días hábiles, esto está sujeto a cambios dependiendo del Activo depositado en custodia en nuestra empresa.7. Limitación de responsabilidad: a. La Compañía no será responsable de ningún daño directo, indirecto, incidental, especial, consecuente o ejemplar que resulte de la inversión en el Producto, excepto lo expresamente dispuesto en este acuerdo.8. Ley Aplicable y Jurisdicción: a. Este acuerdo se regirá e interpretará de acuerdo con las leyes de [insertar jurisdicción aplicable]. b. Cualquier disputa que surja de este acuerdo o esté relacionada con él estará sujeta a la jurisdicción exclusiva de los tribunales de [insertar jurisdicción aplicable].9. Acuerdo completo: a. Este acuerdo constituye el entendimiento y acuerdo completo entre el Cliente y la Compañía con respecto a la inversión en el Producto y reemplaza cualquier acuerdo o entendimiento anterior, ya sea oral o escrito.Al firmar a continuación, el Cliente reconoce y acepta los términos y condiciones anteriores:Cliente: [Nombre del cliente]Fecha: [Fecha]Empresa: [Nombre de la empresa]Fecha: [Fecha]Los siguientes términos y condiciones rigen la relación entre el Fideicomitente, el Fiduciario Ejecutivo y el Beneficiario para la creación y administración de un fideicomiso. Al celebrar este acuerdo, todas las partes reconocen y aceptan los siguientes términos y condiciones:1. Creación de Confianza: a. Por la presente, el Fideicomitente solicita y acepta que el Fideicomitente Ejecutivo cree un fideicomiso para que el Fideicomitente pueda transferir los activos especificados al fideicomiso en beneficio del Beneficiario o Beneficiarios. b. El Síndico Ejecutivo mantendrá, administrará, aprovechará y colocará los activos del fideicomiso de conformidad con los términos de este acuerdo.2. Administración del Fideicomiso: a. El Síndico Ejecutivo tendrá el poder y la autoridad para administrar, invertir y distribuir los activos del fideicomiso únicamente para beneficio del Beneficiario. b. El Síndico Ejecutivo actuará de buena fe y de conformidad con las leyes y reglamentos aplicables que rigen la administración de fideicomisos.3. Deberes y Responsabilidades: a. El Fideicomitente reconoce que el Síndico Ejecutivo es responsable de la gestión y administración prudentes de los activos del fideicomiso. De tal manera, que el/los beneficiario/s recibirán un rendimiento del 20% de cada uso de apalancamiento producido por el Fiduciario por la utilización del fideicomiso. b. El Fideicomitente y el Beneficiario reconocen que tienen derecho a solicitar y recibir información sobre los activos y transacciones del fideicomiso.4. Derechos del Beneficiario: a. El Beneficiario tendrá derecho a recibir ingresos y/o distribuciones de capital del fideicomiso según lo determine el Síndico Ejecutivo. b. El Beneficiario tendrá derecho a solicitar y recibir información sobre los activos y transacciones del fideicomiso.5. Limitación de responsabilidad: a. El Fideicomisario Ejecutivo no será responsable de ningún daño directo, indirecto, incidental, especial, consecuente o ejemplar que resulte de la administración del fideicomiso, excepto lo expresamente dispuesto en este acuerdo.6. Terminación del Fideicomiso: a. El fideicomiso continuará hasta que el Fideicomitente lo rescinda o según lo dispuesto en este acuerdo. b. Al terminar el fideicomiso, los activos del fideicomiso se distribuirán al Beneficiario de acuerdo con los términos de este acuerdo.7. Ley Aplicable y Jurisdicción: a. Este acuerdo se regirá e interpretará de acuerdo con las leyes de la jurisdicción en la que se establece el fideicomiso. b. Cualquier disputa que surja de este acuerdo o esté relacionada con él estará sujeta a la jurisdicción exclusiva de los tribunales de la jurisdicción en la que se establece el fideicomiso.8. Acuerdo completo: a. Este acuerdo constituye el entendimiento y acuerdo completo entre el Fideicomitente, el Fiduciario Ejecutivo y el Beneficiario con respecto a la creación y administración del fideicomiso y reemplaza cualquier acuerdo o entendimiento previo, ya sea oral o escrito.TÉRMINOS Y CONDICIONES PARA PROGRAMAS DE INVERSIÓN DE ALTO RIESGOLea atentamente estos términos y condiciones antes de colocar y prometer fondos en programas de inversión de alto riesgo, ya sean nacionales o internacionales. Al participar en estos programas, usted reconoce que ha leído, comprendido y aceptado regirse por los términos y condiciones que se describen a continuación. Si no está de acuerdo con estos términos y condiciones, absténgase de participar en programas de inversión de alto riesgo.1. Conciencia del riesgo: El cliente reconoce y comprende que los programas de inversión de alto riesgo implican riesgos e incertidumbres sustanciales. Estos riesgos pueden resultar en la pérdida de parte o de la totalidad de los fondos invertidos. El cliente es el único responsible de evaluar los riesgos asociados con estos programas y entiende que el Administrador no ofrece ninguna garantía o seguridad con respecto a los resultados de la inversión.2. Acuerdo de exención de responsabilidad: El cliente acepta eximir de responsabilidad al Administrador de todos y cada uno de los reclamos, pérdidas, daños, responsabilidades, costos y gastos que surjan como resultado de participar en programas de inversión de alto riesgo. El cliente reconoce que es el único responsible de sus decisiones de inversión y asume el riesgo asociado con estos programas.3. Compensación por Apoyo Financiero: En el caso de que el cliente brinde apoyo financiero para programas que pongan en riesgo menor sus fondos o activos o los del fideicomitente, el Administrador podrá compensar al cliente. La compensación se determinará en función del uso y la duración de los activos o fondos bloqueados y oscilará entre el 5 y el 20 por ciento. El acuerdo de compensación específico será aprobado previamente por el cliente o fideicomitente.4. Aprobación de Activos o Fondos Bloqueados: El cliente o fideicomitente reconoce que cualquier activo o fondo bloqueado involucrado en programas de inversión de alto riesgo será aprobado previamente por ellos. El Administrador no procederá con ninguna transacción o inversión sin la aprobación explícita del cliente o fideicomitente.5. Disposiciones diversas: a. Estos términos y condiciones constituyen el acuerdo completo entre el cliente y el Administrador con respecto a programas de inversión de alto riesgo. b. Estos términos y condiciones podrán ser modificados o enmendados por el Administrador a su discreción. Cualquier modificación o enmienda entrará en vigor al publicar los términos y condiciones actualizados en el sitio web del Administrador o notificar por escrito al cliente. C. Estos términos y condiciones se regirán e interpretarán de conformidad con las leyes de [Jurisdicción]. d. Cualquier disputa que surja de la interpretación o ejecución de estos términos y condiciones se resolverá mediante arbitraje de acuerdo con las reglas de Arbitraje privado en el estado de Florida de los Estados Unidos de América. mi. Si alguna disposición de estos términos y condiciones se considera inválida o inaplicable, dicha disposición se separará de las disposiciones restantes, que permanecerán en pleno vigor y efecto.Al colocar y prometer fondos en programas de inversión de alto riesgo, usted confirma que ha leído, comprendido y aceptado estos términos y condiciones.Soluciones de arbitraje para clientes, fideicomisarios, fideicomitentes, beneficiarios y clientesCon el fin de proporcionar un proceso de resolución justo y eficiente para cualquier disputa que pueda surgir entre clientes, fiduciarios, fideicomitentes, beneficiarios y clientes, se proponen las siguientes soluciones de arbitraje:1. Mediación: antes de iniciar un arbitraje formal, se anima a todas las partes involucradas a participar en una mediación. La mediación es un proceso voluntario en el que un tercero neutral ayuda a las partes a llegar a una resolución mutuamente aceptable. El mediador facilita las discusiones y ayuda a las partes a explorar opciones para llegar a un acuerdo. La mediación es una alternativa rentable y eficiente en términos de tiempo al litigio tradicional.2. Arbitraje: si la mediación no tiene éxito o no se elige como opción, las partes acuerdan recurrir al arbitraje como siguiente paso en el proceso de resolución de disputas. El arbitraje es un proceso privado, confidencial y legalmente vinculante en el que se designa a un árbitro o panel de árbitros imparcial para escuchar las pruebas y tomar una decisión final sobre la disputa. La decisión del árbitro(s) es definitiva y vinculante para todas las partes involucradas.3. Selección de Árbitro(s): Las partes acuerdan seleccionar conjuntamente un árbitro(s) calificado e independiente para presidir el procedimiento de arbitraje. Si las partes no pueden ponerse de acuerdo sobre uno o varios árbitros, presentarán el asunto a una institución de arbitraje independiente o a una autoridad nominadora para realizar la selección.4. Reglas de Arbitraje: El procedimiento de arbitraje se conducirá de acuerdo con las reglas y procedimientos acordados por las partes o, en defecto de acuerdo, las reglas de una institución de arbitraje reconocida. Las partes cooperarán de buena fe para garantizar un proceso de arbitraje justo, eficiente y oportuno.5. Ejecución del laudo arbitral: Las partes acuerdan acatar y cumplir con cualquier laudo arbitral dictado por el(los) árbitro(s). El laudo será ejecutable en cualquier tribunal que tenga jurisdicción sobre el asunto.6. Confidencialidad: Todos los aspectos del procedimiento de arbitraje, incluida la existencia de la disputa, las pruebas presentadas y el resultado, serán tratados como confidenciales por todas las partes. Las disposiciones de confidencialidad sobrevivirán a la terminación del procedimiento de arbitraje.Al aceptar estas soluciones de arbitraje, las partes reconocen y comprenden que el arbitraje es una alternativa legalmente vinculante al litigio y que una decisión alcanzada mediante arbitraje es definitiva y ejecutable. Además, acuerdan abstenerse de emprender cualquier acción legal adicional relacionada con la disputa, excepto para la ejecución del Lado arbitral.',
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () {
              controller.updateIsTermsAccepted(true);
              Get.back();
            },
            child: const Text('Aceptar Términos y condiciones'),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
