import 'package:flutter/material.dart';

class Styles {
  late BuildContext context;
  late double deviceWidth;

  // Initalizer
  Styles(BuildContext context) {
    this.context = context;
    deviceWidth = MediaQuery.of(context).size.width;
  }

// Appbar needs title
  AppBar appBar(String pageName) {
    return AppBar(
      backgroundColor: Colors.black,
      leading: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: GestureDetector(
          onTap: () {},
          child: Icon(Icons.arrow_back_ios_new),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Text(
          pageName,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
    );
  }
}
