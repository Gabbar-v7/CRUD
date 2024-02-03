import 'package:CRUD/utils/mini_tools.dart';
import 'package:CRUD/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CounterLogic {
  var box = Hive.box<dynamic>('user_data');

  UserDataManager db = UserDataManager('counters_list');
  late List counters = db.getData();

  TextEditingController label = TextEditingController();
  FocusNode labelFocus = FocusNode();
  DateTime start = MiniTool.justDate(DateTime.now());
  bool autogoal = false;
  Map goal = {};
  late Map? updateCounter;

  void setHive() async {
    updateCounter = box.get('update_counter', defaultValue: null);
  }

  CounterLogic() {
    setHive();
    if (updateCounter != null) {
      label.text = updateCounter?['label'];
      start = updateCounter?['startDate'];
    }
  }

  void receive(context) {
    if (label.text != '') {
      Map counter = {
        'label': label.text,
        'startDate': start,
      };
      if (updateCounter == null) {
        counters.insert(0, counter);
      } else {
        counters[counters.indexOf(updateCounter)] = counter;
        updateCounter = null;
        box.put('update_counter', null);
      }
      db.storeData(counters);
    }
  }

  int dayDiff(DateTime thisDate, DateTime fromDate) {
    return thisDate.difference(fromDate).inDays;
  }

  bool popUpClicked(value, data) {
    updateCounter = null;
    if (value == 0) {
      counters.remove(data);
      db.storeData(counters);
      return true;
    } else {
      box.put('update_counter', data);
      return false;
    }
  }
}
