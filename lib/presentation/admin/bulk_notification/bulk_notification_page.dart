import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/presentation/admin/bulk_notification/bulk_notification_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/custom_input.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';

class BulkNotificationPage extends GetView<BulkNotificationController> {
  const BulkNotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Notificación Masiva'),
        ),
        body: CustomCard(
          child: ListView(
            padding: Constants.bodyPadding,
            physics: const ClampingScrollPhysics(),
            children: [
              const InputTitle('Título', isRequired: true),
              CustomInput(
                controller: controller.notificationTitleController,
                focusNode: controller.notificationTitleFocus,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 10),
              const InputTitle('Mensaje', isRequired: true),
              CustomInput(
                controller: controller.notificationMessageController,
                focusNode: controller.notificationMessageFocus,
                textCapitalization: TextCapitalization.sentences,
                minLines: 5,
                maxLines: 8,
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: () => controller.showConfirmation(context),
                child: const Text('Enviar Notificación Masiva'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
