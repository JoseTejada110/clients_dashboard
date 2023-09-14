import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeleton_app/core/constants.dart';

class AppTransaction {
  AppTransaction({
    required this.id,
    required this.transactionBy,
    required this.transactionTo,
    required this.destinationAccount,
    required this.originAccount,
    required this.processedBy,
    required this.amount,
    required this.concept,
    required this.originType,
    required this.destinationType,
    required this.date,
    required this.status,
    required this.voucherImage,
    required this.bankAccountName,
    required this.bankAccountNumber,
  });
  final String id;
  final DocumentReference<Map<String, dynamic>> transactionBy;
  final DocumentReference<Map<String, dynamic>>? transactionTo;
  final DocumentReference<Map<String, dynamic>>? destinationAccount;
  final DocumentReference<Map<String, dynamic>>? originAccount;
  final DocumentReference<Map<String, dynamic>>? processedBy;
  final double amount;
  final String concept;
  final String originType;
  final String destinationType;
  final DateTime date;
  String status;
  final String voucherImage;
  final String bankAccountName;
  final String bankAccountNumber;

  factory AppTransaction.fromJson(Map<String, dynamic> json) => AppTransaction(
        id: json['id'],
        transactionBy: json['transaction_by'],
        transactionTo: json['transaction_to'],
        destinationAccount: json['destination_account'],
        originAccount: json['origin_account'],
        processedBy: json['processed_by'],
        amount: (json['amount']).toDouble(),
        concept: json['concept'] ?? '',
        originType: json['origin_type'] ?? '',
        destinationType: json['origin_type'] ?? '',
        date: (json['date'] as Timestamp).toDate(),
        status: json['status'] ?? '',
        voucherImage: json['voucher_image'] ?? '',
        bankAccountName: json['bank_account_name'] ?? '',
        bankAccountNumber: json['bank_account_number'] ?? '',
      );

  Color getStatusColor() {
    if (status == 'Pendiente') return Constants.red;
    return Constants.green;
  }

  String getType({bool isFromOrigin = true}) =>
      isFromOrigin ? originType : destinationType;

  Color getTypeColor({bool isFromOrigin = true}) {
    final transactionType = isFromOrigin ? originType : destinationType;
    if (transactionType == 'Débito') return Constants.red;
    return Constants.green;
  }
}
