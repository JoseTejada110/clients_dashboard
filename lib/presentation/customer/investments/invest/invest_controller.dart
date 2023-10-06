import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/messages_utils.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/account_model.dart';
import 'package:bisonte_app/data/models/investment_model.dart';
import 'package:bisonte_app/data/models/user_model.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';
import 'package:bisonte_app/presentation/customer/portfolio/customer_portfolio_controller.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class InvestController extends GetxController with StateMixin {
  InvestController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    investment = Get.arguments as Investment;
    loadAdminAccountReference();
    super.onInit();
  }

  Future<void> loadAdminAccountReference() async {
    final adminDataParams = FirebaseParamsRequest(
      collection: 'admin_bank_information',
    );
    GeneralUsecase(apiRepository).readData<dynamic>(adminDataParams).then(
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

  //
  dynamic adminData;
  Investment? investment;
  UserModel user = Utils.getUser();
  final investmentAmountController = TextEditingController();
  final isTermsAccepted = false.obs;

  void updateIsTermsAccepted(bool? val) => isTermsAccepted.value = val ?? false;

  void setAvailableBalance() {
    investmentAmountController.text = Constants.decimalFormat.format(
      user.accounts.first.getAvailableBalance(),
    );
    update(['invested_capital']);
  }

  void showConfirmation(BuildContext context) async {
    final isValidFields = _validateFields();
    if (!isValidFields) return;
    await MessagesUtils.showConfirmation(
      context: context,
      title: 'Confirmar Inversión',
      subtitle: const Text(
          '¿Seguro que desea continuar con el proceso de inversión?'),
      onConfirm: () {
        Navigator.pop(context);
        confirmInvestment();
      },
      onCancel: Get.back,
    );
  }

  Future<void> confirmInvestment() async {
    MessagesUtils.showLoading(message: 'Procesando...');
    final res = await GeneralUsecase(apiRepository)
        .executeFirebaseQueries<Map<String, dynamic>?>(_queries);
    MessagesUtils.dismissLoading();
    res.fold(
      (l) => MessagesUtils.errorDialog(l, tryAgain: confirmInvestment),
      (r) {
        if (r == null) {
          Get.dialog(
            DialogErrorPlaceholcer(
              message: const ErrorResponse(
                title: 'Saldo Insuficiente',
                message:
                    'Su cuenta no posee saldo suficiente para realizar esta inversión.',
              ),
              tryAgain: confirmInvestment,
            ),
          );
          return;
        }

        r['investment_date'] = Timestamp.fromDate(DateTime.now());
        final newInvestment = AccountInvestment.fromJson(r);
        user.accounts.first.accountInvestments.insert(0, newInvestment);

        if (Get.isRegistered<CustomerPortfolioController>()) {
          Get.find<CustomerPortfolioController>()
              .refreshInvestments(isFromOnInit: true);
        }

        Get.back();
        MessagesUtils.successSnackbar(
          'Inversión Procesada',
          'Su inversión ha sido procesada con éxito.',
        );
      },
    );
  }

  Future<Map<String, dynamic>?> _queries() async {
    final db = FirebaseFirestore.instance;
    final user = Utils.getUser();
    // Obteniendo las referencias de las cuentas involucradas
    final clientAccountRef =
        db.collection('accounts').doc(user.accounts.first.id);
    final adminAccountRef = adminData['admin_wallet_reference']
        as DocumentReference<Map<String, dynamic>>;

    // Definiendo la data de la transacción a crear
    final amount = Utils.parseControllerText(investmentAmountController.text);
    final transactionData = {
      'amount': amount,
      'concept': 'Inversión en ${investment!.name.toLowerCase()}',
      'date': FieldValue.serverTimestamp(),
      'destination_account': adminAccountRef,
      'destination_type': 'Crédito',
      'origin_account': clientAccountRef,
      'origin_type': 'Débito',
      'status': 'Procesada',
      'transaction_by': Utils.getUserReference(),
      'bank_account_name': '',
      'bank_account_number': '',
      'transaction_type': 'Inversión',
    };

    // Ejecutando transacción
    return db.runTransaction<Map<String, dynamic>?>((transaction) async {
      // Obteniendo la cuenta del cliente
      final clientValue = await transaction.get(clientAccountRef);
      final clientAccount = Account.fromJson(
        clientValue.data()!..addAll({'id': clientValue.id}),
      );
      if (clientAccount.getAvailableBalance() < amount) {
        user.accounts.first = clientAccount;
        return null;
      }

      transaction.update(
        clientAccountRef,
        {'invested_amount': clientAccount.investedAmount + amount},
      );
      user.accounts.first.investedAmount =
          user.accounts.first.investedAmount + amount;

      //Creando la transacción de la inversión
      final transactionRef = db.collection('transactions').doc();
      transaction.set(transactionRef, transactionData);

      // Actualizando el volumen invertido de la cuenta del administrador
      transaction.update(
        adminAccountRef,
        {'invested_amount': FieldValue.increment(amount)},
      );

      // Creando la inversión a la colección de inversiones del usuario
      final investmentRef = db.collection('user_investments').doc();
      final investmentData = {
        'account': clientAccountRef,
        'earnings_projected': amount * (investment!.returnPercentage / 100),
        'invested_amount': amount,
        'investment': investmentRef,
        'investment_date': FieldValue.serverTimestamp(),
        'end_date': Timestamp.fromDate(investment!.endDate),
        'is_active': true,
        'name': investment!.name,
        'return_percentage': investment!.returnPercentage,
      };
      transaction.set(investmentRef, investmentData);

      return investmentData..addAll({'id': investmentRef.id});
    });
  }

  bool _validateFields() {
    final amount = Utils.parseControllerText(investmentAmountController.text);
    if (amount <= 0) {
      MessagesUtils.errorSnackbar(
        'Introduce el monto a invertir',
        'Debes introducir el monto que vas a invertir',
      );
      return false;
    }
    if (amount < investment!.minimumInvestment) {
      MessagesUtils.errorSnackbar(
        'Monto Mínimo',
        'Debes superar la cantidad mínima de inversión: ${NumberFormat.simpleCurrency().format(investment!.minimumInvestment)}',
      );
      return false;
    }
    if (!isTermsAccepted.value) {
      MessagesUtils.errorSnackbar(
        'Acepta los Términos y Condiciones',
        'Debes aceptar los términos y condiciones de inversión',
      );
      return false;
    }
    return true;
  }
}
