import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dracula_page.dart';
import 'splash_screen.dart';

class DraculaApp extends StatelessWidget {
  const DraculaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home Security System',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: FutureBuilder(
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return const DraculaPage(title: 'Home Security System');
          }
          return const SplashScreen();
        },
      ),
    );
  }
}
