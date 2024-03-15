import 'package:hive_flutter/hive_flutter.dart';

class HiveStatic {
  static Box<dynamic> box = Hive.box<dynamic>('user_data');

  static void storeData(String key, data) => box.put(key, data);

  static dynamic getData(String key, dynamic defaultvalue) =>
      box.get(key, defaultValue: defaultvalue);

  static void deleteKey(key) => box.delete(key);

  static void clear() => box.clear();
}
