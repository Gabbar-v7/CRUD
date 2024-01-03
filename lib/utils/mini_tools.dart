import 'package:hive_flutter/hive_flutter.dart';

class MiniTool {
  var box = Hive.box<dynamic>('user_data');

  bool isSameDay(DateTime day_1, DateTime day_2) {
    return day_1.year == day_2.year &&
        day_1.month == day_2.month &&
        day_1.day == day_2.day;
  }

  DateTime currentDay() {
    DateTime today = DateTime.now();
    return DateTime(today.year, today.month, today.day);
  }

  DateTime lastLoginDate() {
    String key = 'lastLogin';
    dynamic lastLogin = box.get(key, defaultValue: null);
    DateTime today = currentDay();

    if (lastLogin != null && lastLogin.isBefore(today)) {
      box.put(key, today);
      return lastLogin;
    } else {
      return today;
    }
  }

  dynamic mapListDateTimeSorter(List<dynamic> mapList, String date) {
    mapList
        .sort((a, b) => (a[date] as DateTime).compareTo(b[date] as DateTime));
    return mapList;
  }
}
