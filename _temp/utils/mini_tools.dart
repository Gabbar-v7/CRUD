import 'package:flutter/material.dart';

class MiniTool {
  static bool isSameDay(DateTime day_1, DateTime day_2) {
    return day_1.year == day_2.year &&
        day_1.month == day_2.month &&
        day_1.day == day_2.day;
  }

  static DateTime justDate(DateTime day) {
    return DateTime(day.year, day.month, day.day);
  }

  static dynamic mapListDateTimeSorter(List<dynamic> mapList, String date) {
    mapList
        .sort((a, b) => (a[date] as DateTime).compareTo(b[date] as DateTime));
    return mapList;
  }

  static void pushPage(context, page) {
    Future.delayed(Duration.zero, () {
      Navigator.push(context, MaterialPageRoute(builder: (context) => page));
    });
  }

  static pushReplace(context, page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  static void popPage(context) {
    Navigator.pop(context);
  }
}
