import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:bisonte_app/presentation/main_binding.dart';
import 'package:bisonte_app/presentation/routes/app_navigation.dart';
import 'package:bisonte_app/presentation/theme.dart';

@pragma('vm:entry-point')
Future<void> _handleBackgroundNotifications(RemoteMessage message) async {
  //
  // print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseMessaging.onBackgroundMessage(_handleBackgroundNotifications);
  // FirebaseFunctions.instance.useFunctionsEmulator('127.0.0.1', 5001);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bisonte App',
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
      initialRoute: AppRoutes.splash,
      initialBinding: MainBinding(),

      //Estableciendo el tema de la app
      theme: appTheme,
    );
  }
}
