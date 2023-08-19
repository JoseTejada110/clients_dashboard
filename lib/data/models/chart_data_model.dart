import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

List<ChartData> chartDataFromJson(List<dynamic> json) =>
    List<ChartData>.from(json.map((x) => ChartData.fromJson(x)));

class ChartData {
  ChartData({
    this.color1,
    this.color2,
    this.percentage1,
    this.percentage2,
    required this.y1,
    this.y2,
    required this.x1,
    this.x2,
  });
  final Color? color1;
  final Color? color2;
  final String? percentage1;
  final String? percentage2;
  final double y1;
  final double? y2;
  final dynamic x1;
  final dynamic x2;

  factory ChartData.fromJson(Map<String, dynamic> json) => ChartData(
        y1: double.parse((json['y1'] ?? 0).toString()),
        y2: double.parse((json['y2'] ?? 0).toString()),
        x1: DateFormat.MMM('es').format(DateTime.parse(json['x1'])),
        x2: DateFormat.MMM('es').format(DateTime.parse(json['x2'])),
      );
}
