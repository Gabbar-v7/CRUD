import 'package:hive_flutter/hive_flutter.dart';

class UserDataManager {
  late String keyName;
  var box = Hive.box<dynamic>('user_data');
  List<dynamic> storedList = [];

  UserDataManager(key) {
    keyName = key;
  }

  //Crud operations
  void storedData() async {
    storedList = box.get(keyName, defaultValue: [])!;
  }

  List getData() {
    storedData();
    return storedList;
  }

  void storeData(data) async {
    box.put(keyName, data);
  }
}
