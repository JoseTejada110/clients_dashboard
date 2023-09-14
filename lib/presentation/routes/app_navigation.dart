import 'package:get/route_manager.dart';
import 'package:go_router/go_router.dart';
import 'package:skeleton_app/presentation/admin/bulk_notification/bulk_notification_binding.dart';
import 'package:skeleton_app/presentation/admin/bulk_notification/bulk_notification_page.dart';
import 'package:skeleton_app/presentation/admin/clients/verify/verify_binding.dart';
import 'package:skeleton_app/presentation/admin/clients/verify/verify_client_page.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_binding.dart';
import 'package:skeleton_app/presentation/admin/investments/create/create_investments_page.dart';
import 'package:skeleton_app/presentation/admin/transactions/verify/verify_transaction_binding.dart';
import 'package:skeleton_app/presentation/admin/transactions/verify/verify_transaction_page.dart';
import 'package:skeleton_app/presentation/banks/banks_binding.dart';
import 'package:skeleton_app/presentation/banks/banks_page.dart';
import 'package:skeleton_app/presentation/banks/create/create_bank_binding.dart';
import 'package:skeleton_app/presentation/banks/create/create_bank_page.dart';
import 'package:skeleton_app/presentation/customer/investments/invest/invest_binding.dart';
import 'package:skeleton_app/presentation/customer/investments/invest/invest_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_binding.dart';
import 'package:skeleton_app/presentation/customer/transfers/create_transfer/create_transfer_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/deposit_funds/deposit_funds_binding.dart';
import 'package:skeleton_app/presentation/customer/transfers/deposit_funds/deposit_funds_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/transactions/customer_transactions_binding.dart';
import 'package:skeleton_app/presentation/customer/transfers/transactions/customer_transactions_page.dart';
import 'package:skeleton_app/presentation/customer/transfers/withdraw/withdraw_binding.dart';
import 'package:skeleton_app/presentation/customer/transfers/withdraw/withdraw_page.dart';
import 'package:skeleton_app/presentation/home/home_page.dart';
import 'package:skeleton_app/presentation/login/login_binding.dart';
import 'package:skeleton_app/presentation/login/login_page.dart';
import 'package:skeleton_app/presentation/profile/profile_binding.dart';
import 'package:skeleton_app/presentation/profile/profile_page.dart';
import 'package:skeleton_app/presentation/referrals/referrals_binding.dart';
import 'package:skeleton_app/presentation/referrals/referrals_page.dart';
import 'package:skeleton_app/presentation/signup/signup_binding.dart';
import 'package:skeleton_app/presentation/signup/signup_page.dart';
import 'package:skeleton_app/presentation/signup/successful_signup_page.dart';
import 'package:skeleton_app/presentation/splash/splash_binding.dart';
import 'package:skeleton_app/presentation/splash/splash_page.dart';
import 'package:skeleton_app/presentation/support/support_binding.dart';
import 'package:skeleton_app/presentation/support/support_page.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String signUp = '/signUp';
  static const String successfulSignup = '/successfulSignup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String banks = '/banks';
  static const String createBank = '/createBank';
  static const String referrals = '/referrals';

  // ADMIN
  static const String createInvestment = '/createInvestment';
  static const String verifyTransaction = '/verifyTransaction';
  static const String verifyClient = '/verifyClient';
  static const String bulkNotification = '/bulkNotification';

  // CUSTOMER
  static const String invest = '/invest';
  static const String depositFunds = '/depositFunds';
  static const String withdraw = '/withdraw';
  static const String createTransfer = '/createTransfer';
  static const String customerTransactions = '/customerTransactions';
  static const String support = '/support';
}

//
class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginPage(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.signUp,
      page: () => const SignUpPage(),
      binding: SignUpBinding(),
    ),
    GetPage(
      name: AppRoutes.successfulSignup,
      page: () => const SuccessfulSignupPage(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const HomePage(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfilePage(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.banks,
      page: () => const BanksPage(),
      binding: BanksBinding(),
    ),
    GetPage(
      name: AppRoutes.createBank,
      page: () => const CreateBankPage(),
      binding: CreateBankBinding(),
    ),
    GetPage(
      name: AppRoutes.referrals,
      page: () => const ReferralsPage(),
      binding: ReferralsBinding(),
    ),

    // ADMIN
    GetPage(
      name: AppRoutes.createInvestment,
      page: () => const CreateInvestmentsPage(),
      binding: CreateInvestmentsBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyTransaction,
      page: () => const VerifyTransactionPage(),
      binding: VerifyTransactionBinding(),
    ),
    GetPage(
      name: AppRoutes.verifyClient,
      page: () => const VerifyClientPage(),
      binding: VerifyClientBinding(),
    ),
    GetPage(
      name: AppRoutes.bulkNotification,
      page: () => const BulkNotificationPage(),
      binding: BulkNotificationBinding(),
    ),

    // CUSTOMER
    GetPage(
      name: AppRoutes.invest,
      page: () => const InvestPage(),
      binding: InvestBinding(),
    ),
    GetPage(
      name: AppRoutes.depositFunds,
      page: () => const DepositFundsPage(),
      binding: DepositFundsBinding(),
    ),
    GetPage(
      name: AppRoutes.withdraw,
      page: () => const WithdrawPage(),
      binding: WithdrawBinding(),
    ),
    GetPage(
      name: AppRoutes.createTransfer,
      page: () => const CreateTransferPage(),
      binding: CreateTransferBinding(),
    ),
    GetPage(
      name: AppRoutes.customerTransactions,
      page: () => const CustomerTransactionsPage(),
      binding: CustomerTransactionsBinding(),
    ),
    GetPage(
      name: AppRoutes.support,
      page: () => const SupportPage(),
      binding: SupportBinding(),
    ),
  ];
}

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: AppRoutes.signUp,
      builder: (context, state) => const SignUpPage(),
    ),
  ],
);
