import 'dart:io';
import 'package:CRUD/mobile/menu.dart';
import 'package:CRUD/utils/notification_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  NotificationService.init();
  tz.initializeTimeZones();

  await Hive.initFlutter();
  await Hive.openBox('user_data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // showPerformanceOverlay: true,
      title: 'CRUD',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.black, brightness: Brightness.dark),
      home: (!kIsWeb && (Platform.isAndroid || Platform.isIOS))
          ? const MenuPage()
          : const Scaffold(),
    );
  }
}
