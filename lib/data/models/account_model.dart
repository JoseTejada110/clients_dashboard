import 'package:cloud_firestore/cloud_firestore.dart';

class Account {
  Account({
    required this.id,
    required this.netBalance,
    required this.investedAmount,
    required this.frozenAmount,
    required this.transitAmount,
    this.accountInvestments = const <AccountInvestment>[],
  });
  final String id;
  final double netBalance;
  double investedAmount;
  double frozenAmount;
  double transitAmount;
  List<AccountInvestment> accountInvestments;

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'],
      netBalance: (json['net_balance'] ?? 0).toDouble(),
      investedAmount: (json['invested_amount'] ?? 0).toDouble(),
      frozenAmount: (json['frozen_amount'] ?? 0).toDouble(),
      transitAmount: (json['transit_amount'] ?? 0).toDouble(),
      accountInvestments: <AccountInvestment>[],
    );
  }

  double getAvailableBalance() =>
      netBalance - (investedAmount + frozenAmount + transitAmount);
  double getTotalEarningsProjection() {
    return accountInvestments.fold<double>(
      0.0,
      (previousValue, element) =>
          previousValue += element.getEarningsProjection(),
    );
  }
}

class AccountInvestment {
  AccountInvestment({
    required this.id,
    required this.earningsProjected,
    required this.investedAmount,
    required this.returnPercentage,
    required this.investmentDate,
    required this.endDate,
    required this.name,
    required this.isActive,
    this.portfolioPercentage = 0.0,
  });
  final String id;
  final double earningsProjected;
  final double investedAmount;
  final double returnPercentage;
  final DateTime investmentDate;
  final DateTime endDate;
  final String name;
  final bool isActive;

  // Este atributo representa el porcentage que representa esta inversión en el portfolio
  double portfolioPercentage;

  factory AccountInvestment.fromJson(dynamic json) => AccountInvestment(
        id: json['id'],
        earningsProjected: (json['earnings_projected']).toDouble(),
        investedAmount: (json['invested_amount']).toDouble(),
        returnPercentage: (json['return_percentage']).toDouble(),
        investmentDate: (json['investment_date'] as Timestamp).toDate(),
        endDate: (json['end_date'] as Timestamp).toDate(),
        name: json['name'] ?? '',
        isActive: json['is_active'] ?? false,
      );

  double getEarningsProjection() {
    return investedAmount * (returnPercentage / 100);
  }
}
