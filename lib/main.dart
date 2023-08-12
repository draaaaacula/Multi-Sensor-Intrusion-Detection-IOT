import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'dracula_app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); //initialize firebase

  runApp(const PushNotificationHandler());
}

class PushNotificationHandler extends StatefulWidget {
  const PushNotificationHandler({super.key});

  @override
  State<PushNotificationHandler> createState() =>
      PushNotificationHandlerState();
}

class PushNotificationHandlerState extends State<PushNotificationHandler> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void _checkPermission() async {
    if (await _firebaseMessaging.isSupported()) {
      _firebaseMessaging.requestPermission(
        announcement: true, // For iOS only
        sound: true,
        badge: true,
        alert: true,
        provisional: false, // For iOS only
      );
    }
  }

  void _handleOnMessage() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      try {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message.notification!.title!),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
          ),
        );
      }
    });
  }

  void _handleOnMessageOpened() {
    FirebaseMessaging.onMessageOpenedApp.listen((onData) {
      //
    });
  }

  @override
  void initState() {
    super.initState();
    _checkPermission();
    _handleOnMessage();
    _handleOnMessageOpened();
  }

  @override
  Widget build(BuildContext context) {
    return const DraculaApp();
  }
}
