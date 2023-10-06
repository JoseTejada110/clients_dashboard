import 'package:bisonte_app/core/constants.dart';
import 'package:flutter/material.dart';

class InvestmentSummaryRow extends StatelessWidget {
  const InvestmentSummaryRow({
    super.key,
    required this.title,
    required this.data,
    this.dataColor = Constants.green,
  });
  final String title;
  final String data;
  final Color? dataColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title)),
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            data,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: dataColor,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }
}
