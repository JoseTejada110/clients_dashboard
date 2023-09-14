import 'package:skeleton_app/data/models/account_model.dart';

class PortfolioItem {
  PortfolioItem({
    required this.investmentName,
    required this.totalAmount,
    required this.totalProjected,
    required this.returnPercentage,
    required this.investments,
  });
  final String investmentName;
  double totalAmount;
  double totalProjected;
  final double returnPercentage;
  final List<AccountInvestment> investments;
}
