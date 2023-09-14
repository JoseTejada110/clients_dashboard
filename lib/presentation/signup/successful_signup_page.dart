import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:rive/rive.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';

class SuccessfulSignupPage extends StatelessWidget {
  const SuccessfulSignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 150,
                    width: 150,
                    child: RiveAnimation.asset('assets/rives/success.riv'),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Registro Exitoso',
                    style: Get.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Su solicitud de registro se ha completado satisfactoriamente. \nSu perfil se encuentra en estado de verificación, una vez verificado les notificaremos por correo.',
                    textAlign: TextAlign.center,
                    style: Get.textTheme.bodySmall?.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
          CustomBottomButton(
            title: 'Ir a Inicio',
            onTap: () => Get.offAllNamed(AppRoutes.login),
          ),
        ],
      ),
    );
  }
}
