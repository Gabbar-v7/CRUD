import 'package:CRUD/pages/splash.dart';
import 'package:CRUD/utils/app_init.dart';

// Flutter in-built packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
// Managing Hive
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('user_data');

  AppInit().setUp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Set status bar color
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.black));

    return MaterialApp(
      // Hide debug banner
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
      ),
      title: 'CRUD',
      home: const SafeArea(
        child: SplashScreen(),
      ),
    );
  }
}
