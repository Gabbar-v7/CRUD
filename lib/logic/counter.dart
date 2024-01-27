import 'package:CRUD/utils/mini_tools.dart';
import 'package:CRUD/utils/user_data_manager.dart';
import 'package:flutter/material.dart';

class CounterLogic {
  UserDataManager db = UserDataManager('counters_list');
  late List counters = db.getData();

  TextEditingController label = TextEditingController();
  FocusNode labelFocus = FocusNode();
  DateTime start = MiniTool.justDate(DateTime.now());
  bool autogoal = false;
  Map goal = {};

  void receive(context) {
    if (label.text != '') {
      Map counter = {
        'label': label.text,
        'startDate': start,
      };
      counters.insert(0, counter);
      db.storeData(counters);
    }
  }

  int dayDiff(DateTime thisDate, DateTime fromDate) {
    return thisDate.difference(fromDate).inDays;
  }
}
