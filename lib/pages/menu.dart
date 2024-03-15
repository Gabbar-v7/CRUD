import 'package:CRUD/logic/menu.dart';
import 'package:CRUD/pages/test.dart';
import 'package:CRUD/plugs/hive_manager.dart';
import 'package:CRUD/plugs/nav_manager.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({super.key});

  @override
  State<MenuPage> createState() => _MenuPage();
}

class _MenuPage extends State<MenuPage> {
  MenuLogic logic = MenuLogic();
  late Styles appStyle;

  Map pages = {'TestPage': const TestPage()};

  @override
  Future<void> initState() async {
    super.initState();
    NavManager.pushPage(
        context, pages[await HiveStatic.getData('init_page', 'TestPage')]);
  }

  @override
  Widget build(BuildContext context) {
    appStyle = Styles(context);

    return Scaffold(
      appBar: appStyle.appBar('Menu'),
    );
  }
}
