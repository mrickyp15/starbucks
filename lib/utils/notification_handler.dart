import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';

initializeNotification() async {
  final fcm = FirebaseMessaging.instance;

  NotificationSettings settings = await fcm.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');
  print("Token: ${(await fcm.getToken()).toString()}");

  try {
    if(Platform.isIOS) {
      await fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      await fcm.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true
      );

      FirebaseMessaging.onMessage.listen(_onMessage);
      FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onOpened);

      final message = await fcm.getInitialMessage();
      if(message != null) {
        final data = message.data;
        debugPrint("Kamu bisa melakukan apapun dengan data! ${data}");
      }
      debugPrint("Token: ${(await FirebaseMessaging.instance.getToken()).toString()}");
    }
  } catch (e) {
    debugPrint(e.toString());
  }
}

void _onMessage(RemoteMessage message) {
  print('Got a message whilst in the foreground!');
  print('Message data: ${message.data}');

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
  }
}

Future<void> _onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
  debugPrint("Kamu menerima pesan ${message.notification?.title}");
  debugPrint("${message.notification?.body}");
}

void _onOpened(RemoteMessage message) async {
  final data = message.data;
  debugPrint("Kamu bisa melakukan apapun pada data! ${data}");
}