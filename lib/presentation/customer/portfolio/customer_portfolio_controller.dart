import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/animation.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:bisonte_app/core/error_handling/failures.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/account_model.dart';
import 'package:bisonte_app/domain/entities/portfolio_item_entity.dart';
import 'package:bisonte_app/domain/repositories/api_repository.dart';
import 'package:bisonte_app/domain/requests/firebase_params_request.dart';
import 'package:bisonte_app/domain/usecases/general_usecase.dart';

class CustomerPortfolioController extends GetxController with StateMixin {
  CustomerPortfolioController({required this.apiRepository});
  final ApiRepositoryInteface apiRepository;

  @override
  void onInit() {
    refreshInvestments(isFromOnInit: true);
    super.onInit();
  }

  List<Color> chartColors = [];
  final portfolioInvestments = <PortfolioItem>[];

  Future<void> refreshInvestments({bool isFromOnInit = false}) async {
    final firstAccount = Utils.getUser().accounts.first;
    if (isFromOnInit) {
      convertInvestmentsToPortfolioItem(firstAccount.accountInvestments);
      chartColors = List.generate(
        portfolioInvestments.length,
        (index) => _generateSoftColor(),
      );
      change(null,
          status: firstAccount.accountInvestments.isEmpty
              ? RxStatus.empty()
              : RxStatus.success());
      return;
    }
    change(null, status: RxStatus.loading());
    final params = FirebaseParamsRequest(
      collection: 'user_investments',
      parser: AccountInvestment.fromJson,
      whereParams: [
        Filter('is_active', isEqualTo: true),
        Filter(
          'account',
          isEqualTo: FirebaseFirestore.instance
              .collection('accounts')
              .doc(firstAccount.id),
        ),
      ],
      orderBy: FirebaseOrderByParam('investment_date', descending: true),
    );
    final result =
        await GeneralUsecase(apiRepository).readData<AccountInvestment>(params);
    result.fold(
      (failure) {
        change(
          null,
          status: RxStatus.error(getMessageFromFailure(failure).toString()),
        );
      },
      (r) {
        convertInvestmentsToPortfolioItem(r);
        chartColors = List.generate(
          portfolioInvestments.length,
          (index) => _generateSoftColor(),
        );
        firstAccount.accountInvestments = r;
        change(null, status: r.isEmpty ? RxStatus.empty() : RxStatus.success());
      },
    );
  }

  void convertInvestmentsToPortfolioItem(List<AccountInvestment> investments) {
    portfolioInvestments.clear();
    for (final investment in investments) {
      final portfolioIndex = portfolioInvestments.indexWhere(
        (element) => element.investmentName == investment.name,
      );
      if (portfolioIndex != -1) {
        final portfolioItem = portfolioInvestments[portfolioIndex];
        portfolioItem.totalAmount += investment.investedAmount;
        portfolioItem.totalProjected += investment.earningsProjected;
        portfolioItem.investments.add(investment);
      } else {
        portfolioInvestments.add(
          PortfolioItem(
            investmentName: investment.name,
            totalAmount: investment.investedAmount,
            totalProjected: investment.earningsProjected,
            returnPercentage: investment.returnPercentage,
            investments: List.from([investment]),
          ),
        );
      }
    }
  }

  Color _generateSoftColor() {
    final random = Random();
    final r = random.nextInt(256);
    final g = random.nextInt(256);
    final b = random.nextInt(256);
    return Color.fromARGB(200, r, g, b);
  }
}
