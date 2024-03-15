import 'package:flutter/material.dart';
import 'package:CRUD/plugs/nav_manager.dart';

class Styles {
  final BuildContext context;
  late double deviceWidth;
  late double deviceHeigth;

  Styles(this.context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeigth = MediaQuery.of(context).size.height;
  }

  AppBar appBar(String pageName,
          {IconData icon = Icons.arrow_back_ios_new, List<Widget>? actions}) =>
      AppBar(
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavManager.popPage(context),
          icon: Icon(
            icon,
            size: 23.04,
          ),
        ),
        title: Text(
          pageName,
          style: const TextStyle(fontSize: 23.04, fontWeight: FontWeight.w400),
        ),
        actions: actions,
      );

  Padding pageBorder(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 13),
      child: child);
}
