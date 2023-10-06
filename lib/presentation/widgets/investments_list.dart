import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/data/models/investment_model.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';

class InvestmentsList extends StatelessWidget {
  const InvestmentsList({
    super.key,
    required this.onRefresh,
    required this.investments,
    this.isFromCustomerView = false,
  });
  final Future<void> Function() onRefresh;
  final List<Investment> investments;
  final bool isFromCustomerView;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: investments.length,
        itemBuilder: (BuildContext context, int index) {
          return _InvestmentItem(
            investment: investments[index],
            isFromCustomerView: isFromCustomerView,
          );
        },
      ),
    );
  }
}

class _InvestmentItem extends StatelessWidget {
  const _InvestmentItem({
    required this.investment,
    this.isFromCustomerView = false,
  });
  final Investment investment;
  final bool isFromCustomerView;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        investment.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              text:
                  '${Constants.decimalFormat.format(investment.returnPercentage)}% ',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: '(${investment.getMonthBetweenDates()} Meses)',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 14,
                      ),
                ),
              ],
            ),
          ),
          isFromCustomerView
              ? const SizedBox()
              : Text(
                  investment.isAvailable ? 'Disponible' : 'No Disponible',
                  style: TextStyle(
                    color: !investment.isAvailable ? Constants.red : null,
                  ),
                ),
          isFromCustomerView
              ? Text(
                  '${Constants.dateFormat.format(investment.initialDate)} - ${Constants.dateFormat.format(investment.endDate)}',
                  style: TextStyle(
                    color: !investment.isAvailable ? Constants.red : null,
                  ),
                )
              : const SizedBox()
        ],
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        if (isFromCustomerView) {
          Get.toNamed(AppRoutes.invest, arguments: investment);
          return;
        }
        Get.toNamed(AppRoutes.createInvestment, arguments: investment);
      },
    );
  }
}
