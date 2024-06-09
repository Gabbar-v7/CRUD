import 'package:flutter/material.dart';
import 'package:CRUD/utils/nav_manager.dart';
import 'package:flutter/services.dart';

class Styles {
  final BuildContext context;
  late double deviceWidth;
  late double deviceHeigth;

  Styles(this.context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceHeigth = MediaQuery.of(context).size.height;
  }

  AppBar appBar(String pageName,
          {IconData icon = Icons.arrow_back_ios_new,
          List<Widget>? actions,
          Color backgroundColor = Colors.black}) =>
      AppBar(
        backgroundColor: backgroundColor,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.black38, // Set your desired color
          statusBarIconBrightness: Brightness.light, // For Android (dark icons)
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        elevation: 0,
        leading: IconButton(
          onPressed: () => NavManager.popPage(context),
          color: Colors.white,
          icon: Icon(
            icon,
            size: 23.04,
          ),
        ),
        title: Text(
          pageName,
          style: const TextStyle(
              fontSize: 23.04,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        actions: actions,
      );

  Padding pageBorder(Widget child) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      child: child);

  FloatingActionButton floatButton(Icon icon, onPress) => FloatingActionButton(
        backgroundColor: Colors.deepPurple.shade300,
        elevation: 0,
        onPressed: onPress,
        child: icon,
      );
}
