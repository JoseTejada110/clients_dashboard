import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:bisonte_app/core/utils/utils.dart';
import 'package:bisonte_app/presentation/forgot_password/forgot_password_controller.dart';
import 'package:bisonte_app/presentation/widgets/custom_card.dart';
import 'package:bisonte_app/presentation/widgets/custom_input.dart';
import 'package:bisonte_app/presentation/widgets/input_title.dart';

class ForgotPasswordPage extends GetView<ForgotPasswordController> {
  const ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Restablecer Contraseña'),
        ),
        body: Center(
          child: CustomCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const InputTitle('Correo Electrónico', isRequired: true),
                CustomInput(
                  autocorrect: false,
                  controller: controller.emailController,
                  inputAction: TextInputAction.done,
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: controller.resetPassword,
                    child: const Text('Restablecer Contraseña'),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
