import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:skeleton_app/core/constants.dart';
import 'package:skeleton_app/core/utils/utils.dart';
import 'package:skeleton_app/presentation/home/home_controller.dart';
import 'package:skeleton_app/presentation/login/login_controller.dart';
import 'package:skeleton_app/presentation/routes/app_navigation.dart';
import 'package:skeleton_app/presentation/widgets/custom_buttons.dart';
import 'package:skeleton_app/presentation/widgets/custom_input.dart';
import 'package:skeleton_app/presentation/widgets/input_title.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      LoginController(apiRepository: Get.find(), localRepository: Get.find()),
    );
    final themeData = Theme.of(context);
    return GestureDetector(
      onTap: () => Utils.unfocus(context),
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          reverse: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // physics: const ClampingScrollPhysics(),
            children: [
              const _TopLeftWidget(),
              const SizedBox(height: 70),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '¡Bienvenido!',
                      style: themeData.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Iniciar Sesión',
                      style: themeData.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 60),
                    const InputTitle('Correo Electrónico'),
                    CustomInput(
                      autocorrect: false,
                      controller: controller.usernameController,
                      hintText: 'Ingresa tu correo electrónico',
                      textCapitalization: TextCapitalization.none,
                      textInputType: TextInputType.emailAddress,
                      inputAction: TextInputAction.next,
                      suffixIcon: const SizedBox(),
                    ),
                    const SizedBox(height: 30.0),
                    const InputTitle('Contraseña'),
                    Obx(() {
                      return CustomInput(
                        autocorrect: false,
                        controller: controller.passwordController,
                        hintText: 'Ingresa tu contraseña',
                        textCapitalization: TextCapitalization.none,
                        inputAction: TextInputAction.go,
                        isObscure: controller.isObscure.value,
                        suffixIcon: CustomIconButton(
                          onPressed: controller.updatePasswordVisibility,
                          icon: controller.isObscure.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onSubmitted: (_) => loginAndGoToHome(),
                      );
                    }),
                    Obx(() {
                      return CheckboxListTile(
                        value: controller.rememberUsername.value,
                        contentPadding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: controller.updateRememberUsename,
                        title: const Text('Recordar Usuario'),
                      );
                    }),
                    const SizedBox(height: 25.0),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: loginAndGoToHome,
                        child: const Text('Iniciar Sesión'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: CustomTextButton(
                        foregroundColor: Constants.grey,
                        title: '¿No tienes una cuenta? ¡Crea una ahora!',
                        onPressed: () => Get.toNamed(AppRoutes.signUp),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void loginAndGoToHome() async {
    final controller = Get.find<LoginController>();
    final logguedUser = await controller.signIn();
    if (logguedUser == null) return;
    Get.put(
      HomeController(apiRepository: Get.find(), user: logguedUser),
      permanent: true,
    );
    Get.offAllNamed(AppRoutes.home);
  }
}

class _TopLeftWidget extends StatelessWidget {
  const _TopLeftWidget();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: double.infinity,
      child: CustomPaint(
        painter: _CirclePainter(),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Constants.darkIndicatorColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 20;

    final path = Path()
      ..lineTo(0, 150)
      ..quadraticBezierTo(size.width * 0.4, 150, size.width * 0.4, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
