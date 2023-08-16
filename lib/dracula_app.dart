import 'package:flutter/material.dart';
import 'dracula_page.dart';
import 'splash_screen.dart';

class DraculaApp extends StatelessWidget {
  const DraculaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home Security System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(
              title: 'Dracula Security Services',
            ),
        '/home': (context) =>
            const DraculaPage(title: 'Dracula Security Services'),
      },
    );
  }
}
