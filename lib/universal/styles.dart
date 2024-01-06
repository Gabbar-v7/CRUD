import 'package:flutter/material.dart';

class Styles {
  late BuildContext context;
  late double deviceWidth;

  // Initalizer
  Styles(this.context) {
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
          child: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      title: Padding(
        padding: const EdgeInsets.only(top: 11.0),
        child: Text(
          pageName,
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 25),
        ),
      ),
    );
  }
}
