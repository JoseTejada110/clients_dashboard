import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/admin/clients/create/create_clients_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_date_picker.dart';
import 'package:skeleton_app/presentation/widgets/custom_dropdown.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';
import 'package:skeleton_app/presentation/widgets/upload_file_button.dart';

class CreateClientsPage extends GetView<CreateClientsController> {
  const CreateClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Cliente'),
        ),
        body: CustomCard(
          child: Obx(() {
            return Stepper(
              currentStep: controller.currentStep.value,
              controlsBuilder: _buildControlsBuilder,
              onStepContinue: controller.onStepContinue,
              onStepCancel: controller.onStepCancel,
              onStepTapped: controller.onStepTapped,
              steps: [
                Step(
                  isActive: controller.currentStep.value == 0,
                  state: controller.getStepState(0),
                  title: const Text('Información Personal'),
                  content: const _FirstStepContent(),
                ),
                Step(
                  isActive: controller.currentStep.value == 1,
                  state: controller.getStepState(1),
                  title: const Text('Información de Contacto'),
                  content: const _SecondStepContent(),
                ),
                Step(
                  isActive: controller.currentStep.value == 2,
                  state: controller.getStepState(2),
                  title: const Text('Verificación de Identidad'),
                  content: const _ThirdStepContent(),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget _buildControlsBuilder(BuildContext context, ControlsDetails details) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        children: [
          OutlinedButton(
            style: FilledButton.styleFrom(
              foregroundColor: Constants.red,
            ),
            onPressed: details.currentStep == 0 ? null : details.onStepCancel,
            child: const Text(
              'Atrás',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          FilledButton(
            onPressed: details.onStepContinue,
            child: Text(
              details.currentStep == 2 ? 'Guardar' : 'Continuar',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FirstStepContent extends GetView<CreateClientsController> {
  const _FirstStepContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle('Nombre Completo', isRequired: true),
        CustomInput(
          controller: controller.nameController,
          textCapitalization: TextCapitalization.words,
        ),
        const SizedBox(height: 10),
        const InputTitle('Tipo Identificación', isRequired: true),
        Obx(() {
          return CustomDropdown(
            items: controller.tiposIdentificacion,
            value: controller.selectedTipoIdentificacion.value,
            onChanged: (dynamic value) {
              print(value);
            },
          );
        }),
        const SizedBox(height: 10),
        const InputTitle('Identificación', isRequired: true),
        CustomInput(
          controller: controller.identificationController,
        ),
        const SizedBox(height: 10),
        const InputTitle('Fecha Nacimiento', isRequired: true),
        Obx(() {
          return CustomDatePicker(
            initialDateTime: controller.birthdayDate.value,
            maximumDate: DateTime.now(),
            value: controller.birthdayDate.value,
            onDatePicked: controller.pickBirthdayDate,
          );
        }),
      ],
    );
  }
}

class _SecondStepContent extends GetView<CreateClientsController> {
  const _SecondStepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle('Correo Electrónico', isRequired: true),
        CustomInput(
          controller: controller.emailController,
          autocorrect: false,
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        const InputTitle('Número Telefónico', isRequired: true),
        CustomInput(
          controller: controller.phoneController,
          autocorrect: false,
          textInputType: TextInputType.phone,
        ),
        const SizedBox(height: 10),
        const InputTitle('Dirección', isRequired: true),
        CustomInput(
          controller: controller.addressController,
          textInputType: TextInputType.streetAddress,
        ),
      ],
    );
  }
}

class _ThirdStepContent extends GetView<CreateClientsController> {
  const _ThirdStepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle('Imágen documento de identidad', isRequired: true),
        _ImagePickerContainer(
          height: 120,
          width: 220,
          onImagePicked: controller.pickIdentityDocumentImage,
        ),
        const SizedBox(height: 10),
        const InputTitle('Imágen del rostro', isRequired: true),
        _ImagePickerContainer(
          height: 150,
          width: 150,
          onImagePicked: controller.pickfaceImage,
        ),
        const SizedBox(height: 10),
        const InputTitle('Imágen prueba de dirección', isRequired: true),
        _ImagePickerContainer(
          height: 120,
          width: 220,
          onImagePicked: controller.pickDirectionProofImage,
        ),
      ],
    );
  }
}

class _ImagePickerContainer extends StatelessWidget {
  const _ImagePickerContainer({
    this.height = 150,
    this.width = 150,
    required this.onImagePicked,
  });
  final double height;
  final double width;
  final void Function(File) onImagePicked;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [5, 5],
      radius: const Radius.circular(5),
      color: const Color(0XFF494d56),
      strokeWidth: 2,
      child: Container(
        padding: const EdgeInsets.all(15),
        height: 115,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Color(0XFF2a3139),
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UploadFileButton(),
            SizedBox(height: 10),
            Text('Formato .jpg/.jpeg/.png'),
          ],
        ),
      ),
    );
  }
}
