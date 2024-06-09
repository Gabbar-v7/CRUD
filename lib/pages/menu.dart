import 'package:CRUD/pages/test.dart';
import 'package:CRUD/pages/todo_list.dart';
import 'package:CRUD/utils/nav_manager.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hive_flutter/hive_flutter.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  late Styles appStyle = Styles(context);
  Box box = Hive.box('user_data');

  Map pages = {'ToDoPage': const ToDoPage(), 'TestPage': const TestPage()};

  @override
  void initState() {
    super.initState();
    NavManager.pushPage(
        context, pages[box.get('init_page', defaultValue: 'ToDoPage')]);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStyle;
  }

  Column pageColumn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        pageButton('To-Do List', Icons.check, pages['ToDoPage'],
            colour: Colors.white,
            backgroundColor: const Color.fromARGB(
              225,
              39,
              43,
              48,
            )),
        const Gap(15),
        pageButton(
            'Routines', Icons.published_with_changes, pages['TestPage']),
        const Gap(15),
        pageButton('Notes', Icons.sticky_note_2_outlined, pages['TestPage']),
        const Gap(15),
        pageButton('Pomodoro Timer', Icons.timer_sharp, pages['TestPage']),
        const Gap(15),
        pageButton('Counter', Icons.token_outlined, pages['TestPage']),
      ],
    );
  }

  SizedBox pageButton(String title, IconData icon, Widget page,
      {Color colour = const Color.fromARGB(225, 134, 139, 144),
      Color backgroundColor = Colors.transparent}) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => NavManager.pushPage(context, page),
        style: ButtonStyle(
            // overlayColor: WidgetStateProperty.all<Color>(Colors.red),
            alignment: Alignment.centerLeft,
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)))),
            padding: WidgetStateProperty.all<EdgeInsets>(
                const EdgeInsets.symmetric(vertical: 10, horizontal: 20)),
            foregroundColor: WidgetStateProperty.all<Color>(colour),
            backgroundColor: WidgetStateProperty.all<Color>(backgroundColor),
            visualDensity: VisualDensity.adaptivePlatformDensity),
        icon: Icon(
          icon,
          size: 32,
        ),
        label: Text(
          title,
          textWidthBasis: TextWidthBasis.parent,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Container actionButton() {
    return Container(
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2)),
      child: IconButton(
          icon: const Icon(Icons.settings),
          iconSize: 27,
          color: Colors.white,
          onPressed: () => NavManager.pushPage(context, pages['TestPage'])),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appStyle.appBar('Menu'),
      body: appStyle.pageBorder(pageColumn()),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: actionButton(),
    );
  }
}
