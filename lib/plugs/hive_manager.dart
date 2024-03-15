import 'package:hive_flutter/hive_flutter.dart';

class HiveStatic {
  static Box<dynamic> box = Hive.box<dynamic>('user_data');

  static Future<void> storeData(String key, data) async => box.put(key, data);

  static Future<dynamic> getData(String key, dynamic defaultvalue) async =>
      await box.get(key, defaultValue: defaultvalue);

  static Future<void> deleteKey(key) async => box.delete(key);

  static Future<void> clear() async => box.clear();
}
