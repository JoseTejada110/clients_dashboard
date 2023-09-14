import 'package:cloud_firestore/cloud_firestore.dart';

class Investment {
  Investment({
    required this.id,
    required this.createdBy,
    required this.name,
    required this.minimumInvestment,
    required this.maximumInvestment,
    required this.returnPercentage,
    required this.createdAt,
    required this.initialDate,
    required this.endDate,
    required this.isAvailable,
  });
  String id;
  final DocumentReference createdBy;
  final String name;
  final double minimumInvestment;
  final double maximumInvestment;
  final double returnPercentage;
  final DateTime createdAt;
  final DateTime initialDate;
  final DateTime endDate;
  final bool isAvailable;

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        id: json['id'],
        createdBy: json['created_by'],
        name: json['name'] ?? '',
        minimumInvestment: (json['minimum_investment']).toDouble(),
        maximumInvestment: (json['maximum_investment']).toDouble(),
        returnPercentage: (json['return_percentage']).toDouble(),
        createdAt: (json['created_at'] as Timestamp).toDate(),
        initialDate: (json['initial_date'] as Timestamp).toDate(),
        endDate: (json['end_date'] as Timestamp).toDate(),
        isAvailable: json['is_available'],
      );

  Map<String, dynamic> toJson() => {
        'created_by': createdBy,
        'name': name,
        'minimum_investment': minimumInvestment,
        'maximum_investment': maximumInvestment,
        'return_percentage': returnPercentage,
        'created_at': FieldValue.serverTimestamp(),
        'initial_date': Timestamp.fromDate(initialDate),
        'end_date': Timestamp.fromDate(endDate),
        'is_available': isAvailable,
      };

  int getMonthBetweenDates() {
    return endDate.difference(initialDate).inDays ~/ 30;
  }
}
