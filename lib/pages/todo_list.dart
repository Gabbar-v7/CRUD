import 'package:CRUD/pages/test.dart';
import 'package:CRUD/plugs/nav_manager.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  @override
  Widget build(BuildContext context) {
    Styles appStyle = Styles(context);
    return Scaffold(
      appBar: appStyle.appBar('ToDoPage'),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          NavManager.pushPage(context, TestPage());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
