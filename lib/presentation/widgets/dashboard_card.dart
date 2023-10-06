import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';

class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.title,
    required this.icon,
    required this.data,
    this.iconBackgroundColor,
  });
  final String title;
  final IconData icon;
  final String data;
  final Color? iconBackgroundColor;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor:
                iconBackgroundColor ?? Theme.of(context).primaryColor,
            child: Icon(icon, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // const SizedBox(height: 10),
                Text(
                  data,
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
