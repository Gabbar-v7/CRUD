import 'package:CRUD/pages/todolist.dart';

// Flutter in-built packages
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
// Managing Hive
  await Hive.initFlutter();
  var box = await Hive.openBox<List<dynamic>>('test');

  runApp(MyApp());
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
          brightness: Brightness.dark, primarySwatch: Colors.deepPurple),
      title: 'CRUD',
      home: SafeArea(
        child: ToDoList(),
      ),
    );
  }
}
