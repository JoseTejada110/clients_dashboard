import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/presentation/admin/clients/verify/verify_client_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/image_full_screen_wrapper.dart';
import 'package:bisonte_app/presentation/widgets/image_picker_container.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class VerifyClientPage extends GetView<VerifyClientController> {
  const VerifyClientPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verificar Cliente'),
      ),
      body: CustomCard(
        child: ListView(
          padding: Constants.bodyPadding,
          children: [
            const _SectionTitle('Datos Personales'),
            const SizedBox(height: 10),
            const InputTitle('Nombre Completo'),
            _InformativeContainer(data: controller.client.name),
            const SizedBox(height: 10),
            const InputTitle('Tipo de Identificación'),
            _InformativeContainer(data: controller.client.identificationType),
            const SizedBox(height: 10),
            const InputTitle('Identificación'),
            _InformativeContainer(data: controller.client.identification),
            const SizedBox(height: 10),
            const InputTitle('Fecha de Nacimiento'),
            _InformativeContainer(
              data: Constants.dateFormat.format(controller.client.birthdayDate),
            ),
            const SizedBox(height: 10),
            const InputTitle('Código de Referido'),
            _InformativeContainer(
              data: controller.client.referredBy?.id ?? 'N/A',
            ),
            const SizedBox(height: 20),
            const _SectionTitle('Información de Contacto'),
            const SizedBox(height: 10),
            const InputTitle('Número telefónico'),
            IntlPhoneField(
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              initialValue: controller.client.phoneNumber,
              decoration: InputDecoration(
                isDense: true,
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                fillColor: Constants.secondaryColor.withOpacity(.8),
                filled: true,
              ),
              initialCountryCode: controller.client.countryCode,
              languageCode: 'es',
              enabled: false,
            ),
            const SizedBox(height: 10),
            const InputTitle('Dirección'),
            _InformativeContainer(data: controller.client.address),
            const SizedBox(height: 10),
            const InputTitle('Correo Electrónico'),
            _InformativeContainer(data: controller.client.email),
            const SizedBox(height: 20),
            const _SectionTitle('Verificación de Identidad'),
            const SizedBox(height: 10),
            const InputTitle('Imagen del Documento de Identidad'),
            ImageContainer(
              child: ImageFullScreenWrapperWidget(
                child: Image.network(controller.client.identificationImage),
              ),
            ),
            const SizedBox(height: 10),
            const InputTitle('Imagen del Rostro'),
            ImageContainer(
              child: ImageFullScreenWrapperWidget(
                child: Image.network(controller.client.faceImage),
              ),
            ),
            const SizedBox(height: 10),
            const InputTitle('Imagen de la prueba de dirección'),
            ImageContainer(
              child: ImageFullScreenWrapperWidget(
                child: Image.network(controller.client.addressProofImage),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => controller.showConfirmation(context),
                child: const Text('Verificar Cliente'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(
          thickness: 2,
          color: Constants.darkIndicatorColor,
        ),
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const Divider(
          thickness: 2,
          color: Constants.darkIndicatorColor,
        ),
      ],
    );
  }
}

class _InformativeContainer extends StatelessWidget {
  const _InformativeContainer({required this.data});
  final String data;

  @override
  Widget build(BuildContext context) {
    return InputDecorator(
      decoration: InputDecoration(
        enabled: false,
        isDense: true,
        fillColor: Constants.secondaryColor.withOpacity(.8),
        filled: true,
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
      ),
      child: Text(
        data,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}
