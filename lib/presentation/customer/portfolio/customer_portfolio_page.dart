import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/data/models/chart_data_model.dart';
import 'package:skeleton_app/presentation/customer/portfolio/customer_portfolio_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class _Investment {
  _Investment({
    required this.name,
    required this.returnPercentage,
    required this.investedAmount,
    required this.beginDate,
    required this.endDate,
    required this.color,
  });
  final String name;
  final double returnPercentage;
  final double investedAmount;
  final DateTime beginDate;
  final DateTime endDate;
  final Color color;
}

class CustomerPortfolioPage extends StatelessWidget {
  const CustomerPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CustomerPortfolioController(apiRepository: Get.find()),
    );
    final investments = [
      _Investment(
        name: 'Extracción de metales preciosos',
        returnPercentage: 15.00,
        investedAmount: 10000,
        beginDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        color: Constants.blue.withOpacity(.8),
      ),
      _Investment(
        name: 'Desarrollo de inmuebles Las Terrenas',
        returnPercentage: 12.59,
        investedAmount: 10000,
        beginDate: DateTime.now(),
        endDate: DateTime.now().add(const Duration(days: 365)),
        color: Constants.green.withOpacity(.8),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
        actions: const [
          SupportButton(),
          UserMenuButton(),
        ],
      ),
      body: Column(
        children: [
          _PieChart(
            chartData: investments
                .map(
                  (element) => ChartData(
                    y1: element.investedAmount,
                    x1: element.name,
                    percentage1: '50%',
                    color1: element.color,
                  ),
                )
                .toList(),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: CustomCard(
              child: ListView.builder(
                itemCount: investments.length,
                itemBuilder: (BuildContext context, int index) {
                  return _PortfolioItem(investment: investments[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  const _PortfolioItem({required this.investment});
  final _Investment investment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        investment.name,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // const Text('Retorno esperado: '),
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
                      text:
                          '(${NumberFormat.simpleCurrency().format(investment.investedAmount * (investment.returnPercentage / 100))})',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontSize: 14,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            '${Constants.dateFormat.format(investment.beginDate)} - ${Constants.dateFormat.format(investment.endDate)} (${investment.endDate.difference(investment.beginDate).inDays ~/ 30} meses)',
          ),
        ],
      ),
      trailing: Text(
        NumberFormat.simpleCurrency().format(10000),
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
        ),
      ),
      onTap: () {
        print('GO TO INVESTMENT DETAILS');
      },
    );
  }
}

class _PieChart extends StatelessWidget {
  const _PieChart({
    required this.chartData,
  });
  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: Constants.bodyPadding,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputTitle('Reparto de activos'),
          Expanded(
            child: SfCircularChart(
              margin: EdgeInsets.zero,
              legend: Legend(
                isVisible: true,
                width: '45%',
                legendItemBuilder: (legendText, series, point, seriesIndex) {
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                    child: Row(
                      children: [
                        Icon(
                          Icons.donut_large,
                          color: point.pointColor,
                        ),
                        const SizedBox(width: 5),
                        Expanded(
                          child: Text(
                            legendText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              series: [
                DoughnutSeries<ChartData, String>(
                  dataSource: chartData,
                  enableTooltip: true,
                  xValueMapper: (ChartData point, _) => point.x1,
                  yValueMapper: (ChartData point, _) => point.y1,
                  pointColorMapper: (ChartData point, _) => point.color1,
                  dataLabelMapper: (ChartData point, _) => point.percentage1,
                  dataLabelSettings: const DataLabelSettings(isVisible: true),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
