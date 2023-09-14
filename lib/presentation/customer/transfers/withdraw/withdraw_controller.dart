import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/account_model.dart';
import 'package:skeleton_app/data/models/bank_model.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class WithdrawController extends GetxController with StateMixin {
  WithdrawController({required this.apiRepository});
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
              adminData = r.first;
              change(null, status: RxStatus.success());
            },
          ),
        );
  }

  RxList<Bank> banks = <Bank>[].obs;
  Rxn<Bank> selectedBank = Rxn<Bank>();
  final amountController = TextEditingController();
  UserModel user = Utils.getUser();
  dynamic adminData; //Datos del banco del administrador

  void pickBank(dynamic value) => selectedBank.value = value;
  void addBank(Bank newBank) => banks.add(newBank);
  void setAvailableBalance() {
    amountController.text = Constants.decimalFormat.format(
      user.accounts.first.getAvailableBalance(),
    );
    update(['invested_capital']);
  }

  void showConfirmation(BuildContext context) async {
    final isValidFields = _validateFields();
    if (!isValidFields) return;
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Confirmar Retiro',
      subtitle:
          const Text('¿Seguro que desea continuar con el proceso de retiro?'),
      onConfirm: () {
        Navigator.pop(context);
        withdraw();
      },
      onCancel: Get.back,
    );
  }

  Future<void> withdraw() async {
    MessagesUtils.showLoading();
    final res = await GeneralUsecase(apiRepository)
        .executeFirebaseQueries<Map<String, dynamic>?>(_queries);
    MessagesUtils.dismissLoading();

    res.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: withdraw),
      (r) {
        if (r == null) {
          Get.dialog(
            DialogErrorPlaceholcer(
              message: const ErrorResponse(
                title: 'Saldo Insuficiente',
                message:
                    'Su cuenta no posee saldo suficiente para realizar este retiro.',
              ),
              tryAgain: withdraw,
            ),
          );
          return;
        }

        Get.back();
        MessagesUtils.successSnackbar(
          'Solicitud de Retiro Realizada',
          "Su solicitud de retiro está siendo verificada.\nPuede confirmar el estado de su solicitud de retiro en la sección 'Mis Transacciones'.",
          duration: const Duration(seconds: 8),
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _queries() async {
    final db = FirebaseFirestore.instance;

    // Obteniendo las referencias de las cuentas involucradas
    final clientAccountRef =
        db.collection('accounts').doc(user.accounts.first.id);

    final amount = Utils.parseControllerText(amountController.text);
    final transactionData = {
      'amount': amount,
      'concept': 'Retiro de fondos',
      'date': FieldValue.serverTimestamp(),
      'destination_account': adminData['admin_wallet_reference'],
      'destination_type': 'Crédito',
      'origin_account': clientAccountRef,
      'origin_type': 'Débito',
      'status': 'Pendiente',
      'transaction_by': Utils.getUserReference(),
      'bank_account_name': selectedBank.value!.bankName,
      'bank_account_number': selectedBank.value!.accountNumber,
    };

    return db.runTransaction(
      (transaction) async {
        // Obteniendo la cuenta del cliente y validando el balance
        final clientValue = await transaction.get(clientAccountRef);
        final clientAccount = Account.fromJson(
          clientValue.data()!..addAll({'id': clientValue.id}),
        );
        if (clientAccount.getAvailableBalance() < amount) {
          user.accounts.first = clientAccount;
          return null;
        }

        // Actualizando el saldo frizado del cliente
        transaction.update(
          clientAccountRef,
          {'frozen_amount': FieldValue.increment(amount)},
        );
        user.accounts.first.frozenAmount += amount;

        //Creando la transacción del retiro
        final transactionRef = db.collection('transactions').doc();
        transaction.set(transactionRef, transactionData);

        return transactionData..addAll({'id': transactionRef.id});
      },
    );
  }

  bool _validateFields() {
    ErrorResponse? error;
    if (selectedBank.value == null) {
      error = const ErrorResponse(
        title: 'Introduce el banco',
        message:
            'Debes introducir el banco al que se le depositarán los fondos',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    final amount = Utils.parseControllerText(amountController.text);
    if (amount <= 0) {
      error = const ErrorResponse(
        title: 'Introduce el monto a retirar',
        message: 'Debes introducir el monto que deseas retirar',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    if (amount > user.accounts.first.getAvailableBalance()) {
      error = const ErrorResponse(
        title: 'Balance insuficiente',
        message:
            'El monto introducido es mayor al balance disponible para retirar',
      );
      Get.dialog(DialogErrorPlaceholcer(message: error));
      return false;
    }
    return true;
  }
}
