import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/data/models/app_transaction_model.dart';
import 'package:skeleton_app/data/models/user_model.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';

class TransactionsList extends StatelessWidget {
  const TransactionsList({
    super.key,
    required this.onRefresh,
    required this.transactions,
  });
  final Future<void> Function() onRefresh;
  final List<AppTransaction> transactions;

  @override
  Widget build(BuildContext context) {
    final user = Utils.getUser();
    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        itemCount: transactions.length,
        itemBuilder: (BuildContext context, int index) {
          return _TransactionItem(transaction: transactions[index], user: user);
        },
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  const _TransactionItem({required this.transaction, required this.user});
  final AppTransaction transaction;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        transaction.concept,
        style: const TextStyle(fontWeight: FontWeight.bold),
        maxLines: 2,
      ),
      subtitle: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(Constants.dateFormat.format(transaction.date)),
          Text(
            transaction.status,
            style: TextStyle(
              color: transaction.getStatusColor(),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: Text(
        NumberFormat.simpleCurrency().format(transaction.amount),
        style: TextStyle(
          color: transaction.getTypeColor(),
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
      onTap: user.isAdmin
          ? () =>
              Get.toNamed(AppRoutes.verifyTransaction, arguments: transaction)
          : null,
    );
  }
}
