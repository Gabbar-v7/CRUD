import 'dart:async';
import 'package:CRUD/pages/menu.dart';
import 'package:CRUD/utils/mini_tools.dart';

void changePage(context) {
  Timer(const Duration(milliseconds: 400), () {
    MiniTool.pushReplace(context, const MenuPage());
  });
}
