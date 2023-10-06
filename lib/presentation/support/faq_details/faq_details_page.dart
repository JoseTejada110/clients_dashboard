import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:bisonte_app/core/constants.dart';
import 'package:bisonte_app/data/models/faq_model.dart';
import 'package:bisonte_app/presentation/support/faq_details/faq_details_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/image_full_screen_wrapper.dart';
import 'package:bisonte_app/presentation/widgets/image_picker_container.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class FaqDetailsPage extends GetView<FaqDetailsController> {
  const FaqDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(controller.faq?.title ?? ''),
      ),
      body: controller.obx(
        onError: (error) => ErrorPlaceholder(
          error ?? '',
          tryAgain: controller.loadFaqsSteps,
        ),
        onLoading: const LoadingWidget(),
        (_) => ListView.separated(
          itemCount: controller.faqSteps.length,
          itemBuilder: (BuildContext context, int index) {
            return _StepItem(step: controller.faqSteps[index]);
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 20),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  const _StepItem({required this.step});
  final FaqStep step;

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      padding: Constants.bodyPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Constants.indicatorColor,
                child: Text(
                  step.order.toString(),
                  style: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(child: InputTitle(step.title)),
            ],
          ),
          step.description.isEmpty
              ? const SizedBox()
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Text(step.description),
                ),
          step.stepImage.isEmpty
              ? const SizedBox()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7.0),
                      child: ImageContainer(
                        child: ImageFullScreenWrapperWidget(
                          child: Image.network(step.stepImage),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          Icons.contact_support_outlined,
                          size: 18,
                          color: Theme.of(context).textTheme.bodySmall?.color,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          'Presiona la imagen para verla en pantalla completa',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
