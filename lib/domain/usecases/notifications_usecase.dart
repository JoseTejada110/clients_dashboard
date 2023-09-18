import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

enum AvailableTopic {
  allClients,
  allAdmins,
}

class NotificationUsecase {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future<bool> requestNotificationPermission() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    return settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional;
  }

  Future<String?> getDeviceToken() async => await messaging.getToken();

  Future<void> subscribeToTopic(AvailableTopic topic) async {
    await messaging.subscribeToTopic(topic.name);
  }

  Future<bool> sendNotificationToTopic(
    String title,
    String message,
    String topic,
  ) async {
    try {
      final result = await FirebaseFunctions.instance
          .httpsCallable('sendNotificationToTopic')
          .call({"title": title, "message": message, "topic": topic});
      print(result);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> sendNotificationToUser(
    String uid,
    String title,
    String message,
  ) async {
    try {
      final tokens = <String>[];
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .get();
      for (final element in snapshot.docs) {
        tokens.add(element.id);
      }
      final result = await FirebaseFunctions.instance
          .httpsCallable('sendNotificationToUser')
          .call({"title": title, "message": message, "tokens": tokens});
      print(result);
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
