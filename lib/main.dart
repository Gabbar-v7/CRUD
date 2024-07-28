import 'package:CRUD/pages/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  
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
      theme: ThemeData(scaffoldBackgroundColor: Colors.black,brightness: Brightness.dark),      
      home: const MenuPage(),
    );
  }
}
