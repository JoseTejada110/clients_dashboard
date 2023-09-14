import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/instance_manager.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/bank_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class DepositFundsController extends GetxController with StateMixin {
  DepositFundsController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    loadInitialData();
    super.onInit();
  }

  Future<void> loadInitialData() async {
    change(null, status: RxStatus.loading());
    final user = Utils.getUser();
    if (user.bankAccounts?.path != null) {
      final bankParams = FirebaseParamsRequest(
        collection: user.bankAccounts!.path,
        parser: Bank.fromJson,
      );

      GeneralUsecase(apiRepository).readData<Bank>(bankParams).then(
            (value) => value.fold(
              (l) => change(
                null,
                status: RxStatus.error(getMessageFromFailure(l).toString()),
              ),
              (r) {
                banks.value = r;
              },
            ),
          );
    }

    final bankAccountDataParams = FirebaseParamsRequest(
      collection: 'admin_bank_information',
    );
    GeneralUsecase(apiRepository).readData<dynamic>(bankAccountDataParams).then(
          (value) => value.fold(
            (l) => change(
              null,
              status: RxStatus.error(getMessageFromFailure(l).toString()),
            ),
            (r) {
              bankData = r.first;
              change(null, status: RxStatus.success());
            },
          ),
        );
  }

  RxList<Bank> banks = <Bank>[].obs;
  Rxn<Bank> selectedBank = Rxn<Bank>();
  dynamic bankData; //Datos del banco del administrador
  Rxn<File> voucherImage = Rxn<File>();
  final amountController = TextEditingController();

  void pickBank(dynamic value) => selectedBank.value = value;
  void pickVoucherImage(File image) => voucherImage.value = image;

  void addBank(Bank newBank) => banks.add(newBank);

  void showConfirmation(BuildContext context) async {
    final isValidFields = _validateFields();
    if (!isValidFields) return;
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Confirmar Depósito',
      subtitle:
          const Text('¿Seguro que desea continuar con el proceso de depósito?'),
      onConfirm: () {
        Navigator.pop(context);
        saveDeposit();
      },
      onCancel: Get.back,
    );
  }

  Future<void> saveDeposit() async {
    MessagesUtils.showLoading();
    final user = Utils.getUser();
    final db = FirebaseFirestore.instance;
    final clientAccountRef =
        db.collection('accounts').doc(user.accounts.first.id);
    final amount = Utils.parseControllerText(amountController.text);
    final transactionData = {
      'amount': amount,
      'concept': 'Depósito de fondos',
      'date': FieldValue.serverTimestamp(),
      'destination_account': bankData['admin_wallet_reference'],
      'destination_type': 'Débito',
      'origin_account': FirebaseFirestore.instance
          .collection('accounts')
          .doc(user.accounts.first.id),
      'origin_type': 'Crédito',
      'status': 'Pendiente',
      'transaction_by': Utils.getUserReference(),
      'bank_account_name': selectedBank.value!.bankName,
      'bank_account_number': selectedBank.value!.accountNumber,
    };

    // Almacenando el cheque
    final storageRef = FirebaseStorage.instance.ref();
    final voucherImageRef = storageRef.child(
      'images/transactions/${user.id}/deposito_${DateTime.now().toIso8601String()}',
    );
    await voucherImageRef.putFile(voucherImage.value!);
    transactionData.addAll({
      'voucher_image': await voucherImageRef.getDownloadURL(),
    });
    final result = await GeneralUsecase(apiRepository).executeFirebaseQueries(
      () => db.runTransaction((transaction) async {
        //Actualizando el monto en tránsito del cliente
        transaction.update(
          clientAccountRef,
          {'transit_amount': FieldValue.increment(amount)},
        );
        user.accounts.first.transitAmount += amount;

        //Creando la transacción del depósito
        final transactionRef = db.collection('transactions').doc();
        transaction.set(transactionRef, transactionData);
      }),
    );
    MessagesUtils.dismissLoading();
    result.fold((l) {
      MessagesUtils.errorDialog(l, tryAgain: saveDeposit);
    }, (r) {
      Get.back();
      MessagesUtils.successSnackbar(
        'Depósito Realizado',
        "Su depósito está siendo verificado, una vez verificado se le acreditará a su cuenta.\nPuede confirmar el estado de su depósito en la sección 'Mis Transacciones'.",
        duration: const Duration(seconds: 8),
      );
    });
  }

  bool _validateFields() {
    ErrorResponse? error;
    if (selectedBank.value == null) {
      error = const ErrorResponse(
        title: 'Introduce el banco',
        message: 'Debes introducir el banco desde el que hiciste el depósito',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    final amount = Utils.parseControllerText(amountController.text);
    if (amount <= 0) {
      error = const ErrorResponse(
        title: 'Introduce el monto depositado',
        message:
            'Debes introducir el monto que depositaste en la transferencia',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    if (voucherImage.value == null) {
      error = const ErrorResponse(
        title: 'Sube la imagen del voucher',
        message: 'Debes subir la imagen del recibo de la transferencia',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }

    return true;
  }
}
