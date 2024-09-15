import 'dart:io';
import 'package:flutter/material.dart';

class NavManager {
  static void pushPage(BuildContext context, page) =>
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));

  static void pushReplace(BuildContext context, page) =>
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => page));

  static void popPage(BuildContext context) =>
      (Navigator.canPop(context)) ? Navigator.pop(context) : exit(0);
}
