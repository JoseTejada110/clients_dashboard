import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_notifier.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:get/route_manager.dart';
import 'package:bisonte_app/data/models/faq_model.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';
import 'package:bisonte_app/presentation/support/support_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/placeholders_widgets.dart';

class SupportPage extends GetView<SupportController> {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preguntas Frecuentes'),
      ),
      body: CustomCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: controller.obx(
                onError: (error) => ErrorPlaceholder(
                  error ?? '',
                  tryAgain: controller.loadFaqs,
                ),
                onLoading: const LoadingWidget(),
                (_) => ListView.builder(
                  itemCount: controller.faqs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _FAQItem(faq: controller.faqs[index]);
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 25.0,
                left: 10,
                right: 10,
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.support_agent),
                  label: const Text('Recibir Soporte'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  const _FAQItem({required this.faq});
  final Faq faq;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10),
      title: Text(
        faq.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () => Get.toNamed(AppRoutes.faqDetails, arguments: faq),
    );
  }
}
