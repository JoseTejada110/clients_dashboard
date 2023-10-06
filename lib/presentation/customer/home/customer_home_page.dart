import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/data/models/chart_data_model.dart';
import 'package:bisonte_app/presentation/customer/home/customer_home_controller.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/dashboard_card.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';
import 'package:bisonte_app/presentation/widgets/support_button.dart';
import 'package:bisonte_app/presentation/widgets/user_menu_button.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class CustomerHomePage extends StatelessWidget {
  const CustomerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      CustomerHomeController(apiRepository: Get.find()),
    );
    final userAccount = Utils.getUser().accounts.first;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inicio'),
        actions: const [
          SupportButton(),
          UserMenuButton(),
        ],
      ),
      body: controller.obx(
        onError: (error) => ErrorPlaceholder(
          error ?? '',
          tryAgain: controller.loadUserInvestments,
        ),
        onLoading: const LoadingWidget(),
        (_) => RefreshIndicator(
          onRefresh: controller.loadUserInvestments,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Balance \nNeto',
                      data: NumberFormat.simpleCurrency()
                          .format(userAccount.netBalance),
                      icon: Icons.swap_horiz,
                      iconBackgroundColor: Constants.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DashboardCard(
                      title: 'Balance \nDisponible',
                      data: NumberFormat.simpleCurrency()
                          .format(userAccount.getAvailableBalance()),
                      icon: Icons.money,
                      iconBackgroundColor: Constants.blue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Balance en \nTránsito',
                      data: NumberFormat.simpleCurrency()
                          .format(userAccount.transitAmount),
                      icon: Icons.watch_later_outlined,
                      iconBackgroundColor: Constants.secondaryColor,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DashboardCard(
                      title: 'Balance \nFrizado',
                      data: NumberFormat.simpleCurrency()
                          .format(userAccount.frozenAmount),
                      icon: Icons.lock_outline,
                      iconBackgroundColor: Constants.red,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: DashboardCard(
                      title: 'Balance \nInvertido',
                      data: NumberFormat.simpleCurrency()
                          .format(userAccount.investedAmount),
                      icon: Icons.attach_money,
                      iconBackgroundColor: Constants.green,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: DashboardCard(
                      title: 'Proyección a \nFuturo',
                      data: NumberFormat.simpleCurrency().format(
                          userAccount.getTotalEarningsProjection() +
                              userAccount.netBalance),
                      icon: Icons.show_chart,
                      iconBackgroundColor: Constants.darkIndicatorColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _LineChart(
                chartData: [
                  ChartData(y1: 0, x1: '05/2023'), //18000
                  ChartData(y1: 0, x1: '06/2023'), //17000
                  ChartData(y1: 0, x1: '07/2023'), //20250
                  ChartData(y1: 0, x1: '08/2023'), //21000
                ],
              ),
              const SizedBox(height: 20),
              CustomCard(
                padding: Constants.bodyPadding,
                onPressed: () => Get.toNamed(AppRoutes.depositFunds),
                child: const ListTile(
                  leading: Icon(
                    Icons.attach_money,
                    color: Constants.indicatorColor,
                  ),
                  title: Text('Depositar Fondos'),
                  trailing: Icon(
                    Icons.chevron_right,
                    color: Constants.indicatorColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LineChart extends StatelessWidget {
  const _LineChart({
    required this.chartData,
  });
  final List<ChartData> chartData;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: Constants.bodyPadding,
      height: 300,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const InputTitle('Invertido Últimos 4 meses'),
          Expanded(
            child: SfCartesianChart(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              primaryYAxis: NumericAxis(
                isVisible: false,
                numberFormat: NumberFormat.simpleCurrency(),
              ),
              primaryXAxis: CategoryAxis(
                labelPlacement: LabelPlacement.onTicks,
                tickPosition: TickPosition.outside,
                borderWidth: 0,
                minorGridLines: const MinorGridLines(width: 0),
                majorTickLines: const MajorTickLines(width: 0),
              ),
              trackballBehavior: TrackballBehavior(
                enable: true,
                lineColor: Constants.secondaryColor,
                lineDashArray: const [5, 5],
                markerSettings: const TrackballMarkerSettings(
                  markerVisibility: TrackballVisibilityMode.visible,
                  height: 10,
                  width: 10,
                  borderWidth: 1,
                ),
                hideDelay: 2000,
                activationMode: ActivationMode.singleTap,
              ),
              series: [
                SplineSeries(
                  dataSource: chartData,
                  xValueMapper: (ChartData point, _) => point.x1,
                  yValueMapper: (ChartData point, _) => point.y1,
                  color: Constants.darkIndicatorColor,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
