import 'package:CRUD/logic/menu.dart';
import 'package:CRUD/pages/counter.dart';
import 'package:CRUD/pages/todolist.dart';
import 'package:CRUD/universal/styles.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  MenuLogic logic = MenuLogic();
  late Styles appStyle;

  Map pages = {'To-Do List': const ToDoPage(), 'Counter': const CounterPage()};

  // Runs as soon as class is initialized
  @override
  void initState() {
    super.initState();
    logic.menuPushPage(context, pages['Counter']);
  }

  Padding pageLayout() {
    return Padding(
      padding: const EdgeInsets.only(top: 100, right: 40, left: 40, bottom: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Pages
          Column(
            children: [
              _pageButton('To-Do List', pages['To-Do List']),
              _pageButton('Counter', pages['Counter']),
            ],
          ),

          //Settings
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_settings()],
          )
        ],
      ),
    );
  }

  Padding _pageButton(String label, page) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: TextButton(
          onPressed: () {
            logic.menuPushPage(context, page);
          },
          child: Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(20)),
            child: SizedBox(
              width: appStyle.deviceWidth * 0.7,
              height: 45,
              child: Center(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 25, color: Colors.white),
                ),
              ),
            ),
          )),
    );
  }

  IconButton _settings() {
    return IconButton(
        onPressed: () {},
        icon: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white),
              borderRadius: BorderRadius.circular(100)),
          padding: const EdgeInsets.all(4),
          child: const Icon(
            Icons.settings,
            size: 30,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    appStyle = Styles(context);

    return Scaffold(
      appBar: appStyle.appBar(context, 'Menu'),
      body: pageLayout(),
    );
  }
}
