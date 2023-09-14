import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/signup/signup_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/custom_date_picker.dart';
import 'package:skeleton_app/presentation/widgets/custom_dropdown.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/image_picker_container.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';

class SignUpPage extends GetView<SignUpController> {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Registro'),
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
                  title: const Text('Información de Contacto y Acceso'),
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
              details.currentStep == 2 ? 'Registrarme' : 'Continuar',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class _FirstStepContent extends GetView<SignUpController> {
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
        const InputTitle('Tipo de Identificación', isRequired: true),
        Obx(() {
          return CustomDropdown(
            items: controller.identificationTypes,
            value: controller.selectedIdentificationType.value,
            onChanged: controller.pickIdentificationType,
          );
        }),
        const SizedBox(height: 10),
        const InputTitle('Identificación', isRequired: true),
        CustomInput(
          controller: controller.identificationController,
        ),
        const SizedBox(height: 10),
        const InputTitle('Fecha de Nacimiento', isRequired: true),
        Obx(() {
          return CustomDatePicker(
            initialDateTime: controller.birthdayDate.value ?? DateTime.now(),
            maximumDate: DateTime.now(),
            value: controller.birthdayDate.value,
            onDatePicked: controller.pickBirthdayDate,
          );
        }),
        const SizedBox(height: 10),
        const InputTitle('Código de Referido'),
        CustomInput(
          controller: controller.referralCodeController,
        ),
      ],
    );
  }
}

class _SecondStepContent extends GetView<SignUpController> {
  const _SecondStepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        const SizedBox(height: 10),
        const InputTitle('Correo Electrónico', isRequired: true),
        CustomInput(
          controller: controller.emailController,
          autocorrect: false,
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 10),
        const InputTitle('Contraseña', isRequired: true),
        CustomInput(
          controller: controller.passController,
          autocorrect: false,
          textInputType: TextInputType.visiblePassword,
          isObscure: true,
          // isObscure: ,
        ),
        const SizedBox(height: 10),
        const InputTitle('Confirmar Contraseña', isRequired: true),
        CustomInput(
          controller: controller.confirmPassController,
          autocorrect: false,
          textInputType: TextInputType.visiblePassword,
          isObscure: true,
        ),
      ],
    );
  }
}

class _ThirdStepContent extends GetView<SignUpController> {
  const _ThirdStepContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const InputTitle('Imagen documento de identidad', isRequired: true),
        Obx(() {
          return ImagePickerContainer(
            pickedImage: controller.identityDocumentImage.value,
            height: 120,
            width: 220,
            onImagePicked: controller.pickIdentityDocumentImage,
          );
        }),
        const SizedBox(height: 10),
        const InputTitle('Imagen del rostro', isRequired: true),
        Obx(() {
          return ImagePickerContainer(
            pickedImage: controller.faceImage.value,
            height: 150,
            width: 150,
            onImagePicked: controller.pickfaceImage,
          );
        }),
        const SizedBox(height: 10),
        const InputTitle('Imagen prueba de dirección', isRequired: true),
        Obx(() {
          return ImagePickerContainer(
            pickedImage: controller.directionProofImage.value,
            height: 120,
            width: 220,
            onImagePicked: controller.pickDirectionProofImage,
          );
        }),
      ],
    );
  }
}
