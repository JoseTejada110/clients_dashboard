import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:skeleton_app/core/error_handling/failures.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}

class EmptyPlaceHolder extends StatelessWidget {
  const EmptyPlaceHolder({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        SliverFillRemaining(
          child: Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class ErrorPlaceholder extends StatelessWidget {
  const ErrorPlaceholder(
    this.message, {
    super.key,
    this.tryAgain,
    this.buttonTitle = 'Intentar de Nuevo',
  });
  final String message;
  final Future<void> Function()? tryAgain;
  final String buttonTitle;

  @override
  Widget build(BuildContext context) {
    final splittedMessage = message.split('|');
    final title = splittedMessage.isEmpty ? "" : splittedMessage[0];
    final content = splittedMessage.length < 2 ? "" : splittedMessage[1];
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //TODO: Mostrar Ícono
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              content,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: tryAgain == null ? 0 : 20),
            tryAgain == null
                ? const SizedBox()
                : FilledButton(
                    onPressed: tryAgain,
                    child: Text(buttonTitle),
                  ),
          ],
        ),
      ),
    );
  }
}

class DialogErrorPlaceholcer extends StatelessWidget {
  const DialogErrorPlaceholcer({
    super.key,
    required this.message,
    this.tryAgain,
  });
  final ErrorResponse message;
  final Future<void> Function()? tryAgain;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            //TODO: Mostrar imagen/ícono
            Text(
              message.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              message.message,
              style: const TextStyle(
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Get.back(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      ),
    );
  }
}
