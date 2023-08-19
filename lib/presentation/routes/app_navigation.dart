import 'package:get/route_manager.dart';
import 'package:skeleton_app/presentation/admin/clients/create/create_clients_binding.dart';
import 'package:skeleton_app/presentation/admin/clients/create/create_clients_page.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_binding.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_page.dart';
import 'package:skeleton_app/presentation/customer/investments/details/investments_details_binding.dart';
import 'package:skeleton_app/presentation/customer/investments/details/investments_details_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_binding.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_page.dart';
import 'package:skeleton_app/presentation/home/home_page.dart';
import 'package:skeleton_app/presentation/login/login_binding.dart';
import 'package:skeleton_app/presentation/login/login_page.dart';
import 'package:skeleton_app/presentation/splash/splash_binding.dart';
import 'package:skeleton_app/presentation/splash/splash_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';

  // ADMIN
  static const String createInvestment = '/createInvestment';
  static const String createClient = '/createClient';

  // CUSTOMER
  static const String investmentDetails = '/investmentDetails';
  static const String createTransfer = '/createTransfer';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),

    // ADMIN
    GetPage(
      name: AppRoutes.createInvestment,
      page: () => const CreateInvestmentsPage(),
      binding: CreateInvestmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.createClient,
      page: () => const CreateClientsPage(),
      binding: CreateClientsBinding(),
    ),

    // CUSTOMER
    GetPage(
      name: AppRoutes.investmentDetails,
      page: () => const InvestmentDetailsPage(),
      binding: InvestmentDetailsBinding(),
    ),
    GetPage(
      name: AppRoutes.createTransfer,
      page: () => const CreateTransferPage(),
      binding: CreateTransferBinding(),
    ),
  ];
}
