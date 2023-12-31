import 'package:hive_flutter/hive_flutter.dart';

class UserDataManager {
  late String keyName;
  var box = Hive.box<List<dynamic>>('user_data');
  List<dynamic> storedList = [];

  UserDataManager(keyName) {
    this.keyName = keyName;
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
