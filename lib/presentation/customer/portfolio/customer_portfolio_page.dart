import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/account_model.dart';
import 'package:skeleton_app/data/models/chart_data_model.dart';
import 'package:skeleton_app/domain/entities/portfolio_item_entity.dart';
import 'package:skeleton_app/presentation/customer/portfolio/customer_portfolio_controller.dart';
import 'package:skeleton_app/presentation/home/home_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomerPortfolioPage extends StatelessWidget {
  const CustomerPortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CustomerPortfolioController(apiRepository: Get.find()),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portafolio'),
        actions: const [
          SupportButton(),
          UserMenuButton(),
        ],
      ),
      body: controller.obx(
          onError: (error) => ErrorPlaceholder(
                error ?? '',
                tryAgain: controller.refreshInvestments,
              ),
          onEmpty: ErrorPlaceholder(
            'No tienes inversiones|Ve a la sección de inversiones y explora todas nuestras opciones.',
            tryAgain: () async => Get.find<HomeController>().updateMenuIndex(2),
            buttonTitle: '¡Invertir Ahora!',
          ),
          onLoading: const CustomCard(child: LoadingWidget()), (_) {
        return Column(
          children: [
            _PieChart(
              chartData: List.generate(
                controller.portfolioInvestments.length,
                (index) => ChartData(
                  y1: controller.portfolioInvestments[index].totalAmount,
                  x1: controller.portfolioInvestments[index].investmentName,
                  color1: controller.chartColors[index],
                  percentage1:
                      '${((controller.portfolioInvestments[index].totalAmount / Utils.getUser().accounts.first.investedAmount) * 100).toStringAsFixed(2)}%',
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: CustomCard(
                child: RefreshIndicator(
                  onRefresh: controller.refreshInvestments,
                  child: ListView.builder(
                    itemCount: controller.portfolioInvestments.length,
                    itemBuilder: (BuildContext context, int index) {
                      return _PortfolioItem(
                        portfolioItem: controller.portfolioInvestments[index],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}

class _PortfolioItem extends StatelessWidget {
  const _PortfolioItem({required this.portfolioItem});
  final PortfolioItem portfolioItem;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      collapsedTextColor: null,
      textColor: Constants.indicatorColor,
      title: Text(
        portfolioItem.investmentName,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            NumberFormat.simpleCurrency().format(portfolioItem.totalAmount),
            style: const TextStyle(fontSize: 15),
          ),
          _EarningsProjectedRichText(
            returnPercentage: portfolioItem.returnPercentage,
            earningsProjected: portfolioItem.totalProjected,
          ),
        ],
      ),
      children: portfolioItem.investments
          .map((investment) => _InvestmentItem(investment: investment))
          .toList(),
    );
  }
}

class _InvestmentItem extends StatelessWidget {
  const _InvestmentItem({required this.investment});
  final AccountInvestment investment;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        DateFormat('dd/MM/yyyy').add_jm().format(investment.investmentDate),
      ),
      subtitle: _EarningsProjectedRichText(
        returnPercentage: investment.returnPercentage,
        earningsProjected: investment.earningsProjected,
      ),
      trailing: Text(
        NumberFormat.simpleCurrency().format(investment.investedAmount),
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

class _EarningsProjectedRichText extends StatelessWidget {
  const _EarningsProjectedRichText({
    required this.returnPercentage,
    required this.earningsProjected,
  });
  final double returnPercentage;
  final double earningsProjected;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '${Constants.decimalFormat.format(returnPercentage)}% ',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
          fontSize: 15,
        ),
        children: [
          TextSpan(
            text:
                '(${NumberFormat.simpleCurrency().format(earningsProjected)})',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
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
                  dataLabelSettings: const DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
