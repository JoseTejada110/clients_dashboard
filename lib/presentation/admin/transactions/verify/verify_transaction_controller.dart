import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/app_transaction_model.dart';
import 'package:bisonte_app/data/models/user_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';
import 'package:bisonte_app/presentation/admin/transactions/admin_transactions_controller.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class VerifyTransactionController extends GetxController with StateMixin {
  VerifyTransactionController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    transaction = Get.arguments as AppTransaction;
    loadUser();
    super.onInit();
  }

  // Cargando el usuario que realizó la transacción
  Future<void> loadUser() async {
    change(null, status: RxStatus.loading());
    final userResult = await transaction.transactionBy.get();
    customer =
        UserModel.fromJson(userResult.data()!..addAll({'id': userResult.id}));
    change(null, status: RxStatus.success());
  }

  late AppTransaction transaction;
  late UserModel customer;

  void showConfirmation(BuildContext context) async {
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Confirmar Transacción',
      subtitle: const Text('¿Seguro que desea confirmar esta transacción?'),
      onConfirm: () {
        Navigator.pop(context);
        processTransaction();
      },
      onCancel: Get.back,
    );
  }

  Future<void> processTransaction() async {
    MessagesUtils.showLoading(message: 'Procesando...');
    final res = await GeneralUsecase(apiRepository)
        .executeFirebaseQueries<bool>(_queries);
    MessagesUtils.dismissLoading();
    res.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: processTransaction),
      (r) {
        // No hay saldo suficiente
        if (r == false) {
          Get.dialog(
            DialogErrorPlaceholcer(
              message: const ErrorResponse(
                title: 'Saldo Insuficiente',
                message:
                    'La cuenta del administrador no posee saldo suficiente para acreditar el monto de la transacción al cliente.',
              ),
              tryAgain: processTransaction,
            ),
          );
          return;
        }

        // Actualizando la transacción correspondiente en el listado de transacciones
        transaction.status = 'Procesada';
        final transactionsController = Get.find<AdminTransactionsController>();
        final indexToReplace = transactionsController.transactions.indexWhere(
          (element) => element.id == transaction.id,
        );
        transactionsController.transactions.removeAt(indexToReplace);
        transactionsController.transactions.insert(indexToReplace, transaction);
        transactionsController.refresh();

        Get.back(result: transaction);
        MessagesUtils.successSnackbar(
          'Transacción Verificada',
          'La transacción ha sido verificada con éxito.',
        );
      },
    );
  }

  Future<bool> _queries() async {
    final db = FirebaseFirestore.instance;

    // Obteniendo las referencias de la transacción y las cuentas involucradas
    final transactionRef = db.collection('transactions').doc(transaction.id);
    final clientAccountRef = transaction.originAccount!;
    final adminAccountRef = transaction.destinationAccount!;

    // Ejecutando transacción
    return db.runTransaction<bool>((firebaseTransaction) async {
      // final adminValue = await firebaseTransaction.get(adminAccountRef);
      // final adminAccount = Account.fromJson(
      //   adminValue.data()!..addAll({'id': adminValue.id}),
      // );
      // if (adminAccount.netBalance < transaction.amount) return false;

      // Actualizando el balance de la cuenta del administrador
      switch (transaction.transactionType) {
        case 'Depósito':
          firebaseTransaction.update(
            adminAccountRef,
            {'net_balance': FieldValue.increment(transaction.amount)},
          );
          firebaseTransaction.update(
            clientAccountRef,
            {'transit_amount': FieldValue.increment(-transaction.amount)},
          );
          break;
        case 'Retiro':
          firebaseTransaction.update(
            adminAccountRef,
            {'net_balance': FieldValue.increment(-transaction.amount)},
          );
          firebaseTransaction.update(
            clientAccountRef,
            {
              'net_balance': FieldValue.increment(-transaction.amount),
              'frozen_amount': FieldValue.increment(-transaction.amount),
            },
          );
          break;
      }

      // Actualizar estado de la transacción y establecer por quién fue procesada
      firebaseTransaction.update(
        transactionRef,
        {'processed_by': Utils.getUserReference(), 'status': 'Procesada'},
      );
      return true;
    });
  }
}
