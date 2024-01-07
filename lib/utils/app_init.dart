import 'package:CRUD/utils/mini_tools.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AppInit {
  var box = Hive.box<dynamic>('user_data');

  void setUp() {
    lastLoginDate();
  }

  DateTime lastLoginDate() {
    dynamic lastLogin = box.get('lastLogin', defaultValue: null);
    DateTime today = MiniTool().currentDay();
    if (lastLogin != null && lastLogin.isBefore(today)) {
      box.put('lastLogin', today);

      return lastLogin;
    } else if (lastLogin == null) {
      box.put('lastLogin', today);

      return today;
    } else {
      return today;
    }
  }
}
