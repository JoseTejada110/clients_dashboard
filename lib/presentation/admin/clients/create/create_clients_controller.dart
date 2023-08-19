import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';

class CreateClientsController extends GetxController {
  CreateClientsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    _loadInitialData();
    super.onInit();
  }

  void _loadInitialData() {
    selectedTipoIdentificacion.value = tiposIdentificacion.first;
  }

  final currentStep = 0.obs;
  final List<dynamic> tiposIdentificacion = [
    {
      'id': 1,
      'descripcion': 'Documento Identidad',
    },
    {
      'id': 2,
      'descripcion': 'Pasaporte',
    },
    {
      'id': 3,
      'descripcion': 'Licencia de Conducir',
    },
  ];

  // Información personal
  final nameController = TextEditingController();
  final selectedTipoIdentificacion = Rxn();
  final identificationController = TextEditingController();
  final birthdayDate = Rxn<DateTime>();

  // Información de contacto
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();

  // Información de verificación de identidad
  final identityDocumentImage = Rxn<File>();
  final faceImage = Rxn<File>();
  final directionProofImage = Rxn<File>();

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
    print('onStepContinue');
    if (currentStep.value < 2) currentStep.value++;
  }

  void onStepCancel() {
    //
    print('onStepCancel');
    if (currentStep.value > 0) currentStep.value--;
  }

  void onStepTapped(int stepTapped) {
    //
    print('onStepTapped');
    print(stepTapped);
    currentStep.value = stepTapped;
  }

  bool _validatePersonalInformation() {
    return true;
  }

  bool _validateContactInformation() {
    return true;
  }

  bool _validateIdentityInformation() {
    return true;
  }
}
