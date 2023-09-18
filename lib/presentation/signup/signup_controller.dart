import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/usecases/notifications_usecase.dart';
import 'package:skeleton_app/domain/usecases/signup_usecase.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';

class SignUpController extends GetxController {
  SignUpController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    _loadInitialData();
    super.onInit();
  }

  void _loadInitialData() {
    selectedIdentificationType.value = identificationTypes.first;
  }

  final currentStep = 0.obs;
  final List<dynamic> identificationTypes = [
    {'id': 1, 'description': 'Documento Identidad'},
    {'id': 2, 'description': 'Pasaporte'},
    {'id': 3, 'description': 'Licencia de Conducir'},
  ];

  // Información personal
  final nameController = TextEditingController();
  final selectedIdentificationType = Rxn();
  final identificationController = TextEditingController();
  final birthdayDate = Rxn<DateTime>();
  final referralCodeController = TextEditingController();

  // Información de contacto y credenciales
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();

  // Información de verificación de identidad
  final identityDocumentImage = Rxn<File>();
  final faceImage = Rxn<File>();
  final directionProofImage = Rxn<File>();

  void pickIdentificationType(dynamic value) =>
      selectedIdentificationType.value = value;
  void pickBirthdayDate(DateTime date) => birthdayDate.value = date;

  void pickIdentityDocumentImage(File image) =>
      identityDocumentImage.value = image;
  void pickfaceImage(File image) => faceImage.value = image;
  void pickDirectionProofImage(File image) => directionProofImage.value = image;

  StepState getStepState(int stepPosition) {
    // cs=currentStep
    final cs = currentStep.value;
    if (stepPosition == cs) return StepState.editing;
    if (stepPosition < cs) return StepState.complete;
    return StepState.indexed;
  }

  void onStepContinue() {
    //
    if (currentStep.value == 0) {
      final isValid = _validatePersonalInformation();
      if (!isValid) return;
    }
    if (currentStep.value == 1) {
      final isValid = _validateContactInformation();
      if (!isValid) return;
    }
    if (currentStep.value == 2) {
      final isValid = _validateIdentityInformation();
      if (!isValid) return;
      createUser();
    }
    if (currentStep.value < 2) currentStep.value++;
  }

  void onStepCancel() {
    if (currentStep.value > 0) currentStep.value--;
  }

  void onStepTapped(int stepTapped) {
    if (currentStep.value == 0 && stepTapped == 1) {
      final isFirstStepValid = _validatePersonalInformation();
      if (!isFirstStepValid) return;
    }
    if (currentStep.value == 0 && stepTapped == 2) {
      final isFirstStepValid = _validatePersonalInformation();
      if (!isFirstStepValid) return;
      final isSecondStepValid = _validateContactInformation();
      if (!isSecondStepValid) {
        currentStep.value = 1;
        return;
      }
    }
    if (currentStep.value == 1 && stepTapped == 2) {
      final isSecondStepValid = _validateContactInformation();
      if (!isSecondStepValid) return;
    }
    currentStep.value = stepTapped;
  }

  // VALIDANDO EL PRIMER STEP
  bool _validatePersonalInformation() {
    if (nameController.text.isEmpty) {
      MessagesUtils.errorSnackbar('Campo Inválido', 'El nombre es obligatorio');
      return false;
    }
    if (selectedIdentificationType.value == null) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'El tipo de identificación es obligatorio',
      );
      return false;
    }
    if (identificationController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La identificación es obligatoria',
      );
      return false;
    }
    if (birthdayDate.value == null) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La fecha de nacimiento es obligatoria',
      );
      return false;
    }
    return true;
  }

  // VALIDANDO EL SEGUNDO STEP
  bool _validateContactInformation() {
    if (phoneController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'El número telefónico es obligatorio',
      );
      return false;
    }
    if (addressController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
          'Campo Inválido', 'La dirección es obligatoria');
      return false;
    }
    if (emailController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'El correo electrónico es obligatorio',
      );
      return false;
    }
    if (passController.text.isEmpty) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La contraseña es obligatoria',
      );
      return false;
    }
    if (passController.text != confirmPassController.text) {
      MessagesUtils.errorSnackbar(
        'Campos Inválidos',
        'Las contraseñas deben ser idénticas',
      );
      return false;
    }
    return true;
  }

  // VALIDANDO EL TERCER STEP
  bool _validateIdentityInformation() {
    if (identityDocumentImage.value == null) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La imagen del documento de identidad es obligatoria',
      );
      return false;
    }
    if (faceImage.value == null) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La imagen del rostro es obligatoria',
      );
      return false;
    }
    if (directionProofImage.value == null) {
      MessagesUtils.errorSnackbar(
        'Campo Inválido',
        'La prueba de dirección es obligatoria',
      );
      return false;
    }
    return true;
  }

  Future<void> createUser() async {
    MessagesUtils.showLoading(message: 'Registrando...');
    final userData = {
      'name': nameController.text,
      'identification_type': selectedIdentificationType.value?['description'],
      'identification': identificationController.text,
      'birthday_date': Timestamp.fromDate(birthdayDate.value!),
      'created_at': FieldValue.serverTimestamp(),
      'phone_number': phoneController.text,
      'address': addressController.text,
      'email': emailController.text,
      'status': 'No Verificado',
      'is_admin': false,
    };
    if (referralCodeController.text.isNotEmpty) {
      userData.addAll({
        'referred_by': FirebaseFirestore.instance
            .collection('users')
            .doc(referralCodeController.text),
      });
    }
    final result = await SignupUsecase(apiRepository).signupUser(
      emailController.text,
      passController.text,
      userData,
      identityDocumentImage.value!,
      faceImage.value!,
      directionProofImage.value!,
    );
    MessagesUtils.dismissLoading();
    result.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: createUser),
      (r) {
        NotificationUsecase().sendNotificationToTopic(
          '¡Nuevo usuario registrado!',
          'Hay un nuevo usuario esperando por tú verificación. ¡Ingresa a la app y verifícalo ahora!',
          AvailableTopic.allAdmins.name,
        );
        Get.offNamed(AppRoutes.successfulSignup);
      },
    );
  }
}
