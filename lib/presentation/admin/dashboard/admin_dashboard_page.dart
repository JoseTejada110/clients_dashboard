import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/data/models/chart_data_model.dart';
import 'package:skeleton_app/presentation/admin/dashboard/admin_dashboard_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_barchart.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/dashboard_card.dart';
import 'package:skeleton_app/presentation/widgets/support_button.dart';
import 'package:skeleton_app/presentation/widgets/user_menu_button.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      AdminDashboardController(apiRepository: Get.find()),
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          SupportButton(),
          UserMenuButton(),
        ],
      ),
      body: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Transacciones \nPendientes',
                  data: '20',
                  icon: Icons.swap_horiz,
                  iconBackgroundColor: Constants.red,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DashboardCard(
                  title: 'Clientes \nPendientes',
                  data: '20',
                  icon: Icons.people,
                  iconBackgroundColor: Constants.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            children: [
              Expanded(
                child: DashboardCard(
                  title: 'Inversiones \nDisponibles',
                  data: '40',
                  icon: Icons.attach_money,
                  iconBackgroundColor: Constants.blue,
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: DashboardCard(
                  title: 'Volúmen \nInvertido',
                  data: '2,000,000',
                  icon: Icons.show_chart,
                  iconBackgroundColor: Constants.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 300,
            child: CustomBarchart(
              legendTitle: 'Ganancias y retornos',
              legend1: 'Ganancias',
              legend2: 'Retorno',
              chartData: [
                ChartData(y1: 60, x1: '06/2023', y2: 50, x2: '06/2023'),
                ChartData(y1: 40, x1: '07/2023', y2: 30, x2: '07/2023'),
                ChartData(y1: 70, x1: '08/2023', y2: 60, x2: '08/2023'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          CustomCard(
            padding: Constants.bodyPadding,
            onPressed: () {
              // TODO: NAVIGATE TO SEND BULK NOTIFICATION PAGE
              print('Enviar notificación');
            },
            child: const ListTile(
              leading: Icon(
                Icons.notifications_active,
                color: Constants.indicatorColor,
              ),
              title: Text('Enviar notificación masiva'),
              trailing: Icon(
                Icons.chevron_right,
                color: Constants.indicatorColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}