import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebasepush/main.dart';

import 'package:firebasepush/notifications_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print('Title: ${message.notification?.title}');
  print('Body: ${message.notification?.body}');
  print('Payload: ${message.data}');
}

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) {
    if (message == null) return;
    navigatorKey.currentState
        ?.pushNamed(NotificationScreen.route, arguments: message);
  }

  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Channel',
      description: 'This is channel is used for important notification',
      importance: Importance.defaultImportance);

  // Future initLocalNotifications() async {

  //   const android = AndroidInitializationSettings('@drawable/ic_launcher');
  //   const settings = InitializationSettings(
  //     android: android,
  //     iOS: IOSInitializationSettings();
  //   );
  //   await _localNotifications.initialize(settings,
  //       onSelectNotification: (payload) {
  //     final message = RemoteMessage.fromMap(
  //       jsonDecode(payload),
  //     );
  //     handleMessage(message);
  //   });
  // }

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCmToken = await _firebaseMessaging.getToken();
    print('Token $fCmToken');
    initPushNotifications();
  }

  Future initPushNotifications() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);

    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);

    FirebaseMessaging.onMessage.listen((message) {
      final notification = message.notification;
      if (notification == null) return;
      _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              channelDescription: _androidChannel.description,
              icon: '@drawable/ic_launcher',
            ),
          ),
          payload: jsonEncode(message.toMap()));
    });
  }
}
