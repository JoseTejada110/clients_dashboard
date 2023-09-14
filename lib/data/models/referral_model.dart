import 'package:cloud_firestore/cloud_firestore.dart';

class Referral {
  Referral({
    required this.id,
    required this.referredBy,
    required this.referredTo,
    required this.earned,
    required this.referredToName,
    required this.date,
  });
  final String id;
  final DocumentReference referredBy;
  final DocumentReference referredTo;
  final double earned;
  final String referredToName;
  final DateTime date;

  factory Referral.fromJson(Map<String, dynamic> json) => Referral(
        id: json['id'],
        referredBy: json['referred_by'],
        referredTo: json['referred_to'],
        earned: (json['earned']).toDouble(),
        referredToName: json['referred_to_name'] ?? '',
        date: (json['date'] as Timestamp).toDate(),
      );
}
