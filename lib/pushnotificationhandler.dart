import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:home_security_system/dracula_app.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceName() async {
  var deviceInfo = DeviceInfoPlugin();
  if (Platform.isAndroid) {
    var androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  } else if (Platform.isIOS) {
    var iosInfo = await deviceInfo.iosInfo;
    return iosInfo.utsname.machine;
  }
  return null;
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
    var name = await getDeviceName();
    var token = await _firebaseMessaging.getToken();
    FirebaseFirestore.instance.collection('devices').doc(name).set({
      'token': token,
    });
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
