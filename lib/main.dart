import 'package:CRUD/pages/menu.dart';
import 'package:CRUD/utils/color_schemes.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox<dynamic>('user_data');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRUD',
      themeMode: ThemeMode.dark,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.white, brightness: Brightness.light),
      darkTheme: ThemeData(colorScheme: darkDefault),
      home: const MenuPage(),
    );
  }
}
