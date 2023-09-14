import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:intl/intl.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/referrals/referrals_controller.dart';
import 'package:skeleton_app/presentation/widgets/custom_card.dart';
import 'package:skeleton_app/presentation/widgets/placeholders_widgets.dart';

class ReferralsPage extends GetView<ReferralsController> {
  const ReferralsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Referidos'),
      ),
      body: CustomCard(
        child: controller.obx(
          onError: (error) => ErrorPlaceholder(
            error ?? '',
            tryAgain: controller.loadReferrals,
          ),
          onLoading: const LoadingWidget(),
          (state) => ListView.separated(
            itemCount: controller.referrals.length,
            itemBuilder: (BuildContext context, int index) {
              final referral = controller.referrals[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: Constants.indicatorColor,
                  child: Text(
                    Utils.getNameShortcuts(referral.referredToName),
                    style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(
                  referral.referredToName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(Constants.dateFormat.format(referral.date)),
                trailing: Text(
                  NumberFormat.simpleCurrency().format(referral.earned),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Constants.green,
                  ),
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const Divider(),
          ),
        ),
      ),
    );
  }
}
