import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});
  static const route = '/notification-screen';

  @override
  Widget build(BuildContext context) {
    final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;
    print(message.notification?.title);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Push Notificastions'),
      ),
      body: Column(
        children: [
          Text('${message.notification?.title}'),
          Text('${message.notification?.body}'),
          Text('${message.data}')
        ],
      ),
    );
  }
}
