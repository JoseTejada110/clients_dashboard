import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/utils/messages_utils.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/bank_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/domain/requests/firebase_params_request.dart';
import 'package:skeleton_app/domain/usecases/general_usecase.dart';
import 'package:skeleton_app/presentation/banks/banks_controller.dart';

class CreateBankController extends GetxController {
  CreateBankController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    _loadSelectedData();
    super.onInit();
  }

  void _loadSelectedData() {
    selectedAccountType.value = accountTypes.first;
    if (Get.arguments == null) return;
    bank = Get.arguments as Bank;
    bankNameController.text = bank!.bankName;
    selectedAccountType.value = accountTypes.firstWhereOrNull(
      (element) => element['description'] == bank!.accountType,
    );
    accountNumberController.text = bank!.accountNumber;
    isBusinessAccount.value = bank!.isBusinessAccount;
  }

  Bank? bank;
  final List<dynamic> accountTypes = [
    {
      'id': 1,
      'description': 'Ahorro',
    },
    {
      'id': 2,
      'description': 'Corriente',
    },
  ];
  final bankNameController = TextEditingController();
  final selectedAccountType = Rxn();
  final accountNumberController = TextEditingController();
  final isBusinessAccount = false.obs;

  void pickAccountType(dynamic value) => selectedAccountType.value = value;
  void switchIsBusinessAccount(bool? value) =>
      isBusinessAccount.value = value ?? false;

  Future<void> createBank() async {
    MessagesUtils.showLoading();
    final user = Utils.getUser();
    late FirebaseParamsRequest params;
    final bankData = {
      'account_number': accountNumberController.text,
      'account_type': selectedAccountType.value['description'],
      'bank_name': bankNameController.text,
      'is_business_account': isBusinessAccount.value,
    };
    params = FirebaseParamsRequest(
      collection: 'users/${user.id}/bank_accounts',
      documentReference: bank == null ? null : user.bankAccounts!.doc(bank!.id),
      data: bankData,
    );
    final result = await GeneralUsecase(apiRepository).writeData(params);
    MessagesUtils.dismissLoading();
    result.fold(
      (l) {
        MessagesUtils.errorDialog(l, tryAgain: createBank);
      },
      (r) {
        bankData.addAll({'id': r});
        final isEditing = bank != null;
        final bankResult = Bank.fromJson(bankData);
        if (isEditing) {
          final bankController = Get.find<BanksController>();
          // final indexToReplace = bankController.banks.indexOf(bank);
          final indexToReplace = bankController.banks.indexWhere(
            (element) => element.id == bank!.id,
          );
          bankController.banks.removeAt(indexToReplace);
          bankController.banks.insert(indexToReplace, bankResult);
          bankController.refresh();
        } else {
          if (Get.isRegistered<BanksController>()) {
            Get.find<BanksController>().banks.insert(0, bankResult);
          }
        }
        Get.back(result: bankResult);
        MessagesUtils.successSnackbar(
          'Cuenta ${isEditing ? 'Editada' : 'Creada'}',
          'La cuenta de banco ha sido ${isEditing ? 'editada' : 'creada'} con éxito.',
        );
      },
    );
  }
}
