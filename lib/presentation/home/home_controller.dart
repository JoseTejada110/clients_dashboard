import 'package:flutter/material.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/domain/repositories/api_repository.dart';
import 'package:skeleton_app/presentation/admin/clients/admin_clients_page.dart';
import 'package:skeleton_app/presentation/admin/dashboard/admin_dashboard_page.dart';
import 'package:skeleton_app/presentation/admin/investments/admin_investments_page.dart';
import 'package:skeleton_app/presentation/admin/transactions/admin_transactions_page.dart';
import 'package:skeleton_app/presentation/customer/home/customer_home_page.dart';
import 'package:skeleton_app/presentation/customer/investments/customer_investments_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/customer_transfers_page.dart';
import 'package:skeleton_app/presentation/customer/portfolio/customer_portfolio_page.dart';

class HomeController extends GetxController {
  HomeController({required this.apiRepository, required this.user});
  final ApiRepositoryInteface apiRepository;
  final UserModel user;

  PageController pageController = PageController();
  RxInt currentIndex = 0.obs;
  void updateMenuIndex(int newIndex) {
    currentIndex.value = newIndex;
    pageController.jumpToPage(newIndex);
  }

  List<Widget> getHomeChildren() {
    if (user.isAdmin) {
      return const [
        AdminDashboardPage(),
        AdminClientsPage(),
        AdminTransactionsPage(),
        AdminInvestmentsPage(),
      ];
    }
    return const [
      CustomerHomePage(),
      CustomerPortfolioPage(),
      CustomerInvestmentsPage(),
      CustomerTransfersPage(),
    ];
  }

  List<BottomNavigationBarItem> getMenuItems() {
    if (user.isAdmin) {
      return const [
        BottomNavigationBarItem(
          icon: Icon(Icons.dashboard),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.people),
          label: 'Clientes',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz),
          label: 'Transacciones',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.attach_money),
          label: 'Inversiones',
        ),
      ];
    }
    return const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home),
        label: 'Inicio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.account_balance_wallet),
        label: 'Portafolio',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.attach_money),
        label: 'Inversiones',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.swap_horiz),
        label: 'Mover Fondos',
      ),
    ];
  }
}
