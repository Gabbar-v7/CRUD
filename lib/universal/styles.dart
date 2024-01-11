import 'package:flutter/material.dart';

class Styles {
  late BuildContext context;
  late double deviceWidth;

  // Initalizer
  Styles(this.context) {
    deviceWidth = MediaQuery.of(context).size.width;
  }

// Appbar needs title
  AppBar appBar(BuildContext context, String pageName,
      {IconData icon = Icons.arrow_back_ios_new}) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(icon),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Text(
          pageName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
    );
  }
}
