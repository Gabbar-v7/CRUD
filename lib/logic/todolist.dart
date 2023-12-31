import 'package:CRUD/utils/mini_tools.dart';
import 'package:CRUD/utils/user_data_manager.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoLogic {
  // Hive
  var box = Hive.box<dynamic>('user_data');
  UserDataManager db = UserDataManager('todo_tasks');

//Screen comunicator variable
  TextEditingController taskName = TextEditingController();
  DateTime today = MiniTool.justDate(DateTime.now());
  late DateTime selectedDate;
  late DateTime lastLogin;

  //Constructor
  ToDoLogic() {
    tasksList = db.getData();
    removeOldCompleteTask();
    orderTask();
  }

  //Task data variable
  late List<dynamic> tasksList = [];
  List<String> subNames = ['Today', 'Pending', 'Future', 'Completed'];
  List<dynamic> orderedList = [];

  void setCurrentDate() {
    selectedDate = today;
  }

  // Removes old completed Tasks
  void removeOldCompleteTask() {
    var lastDelete = box.get('last_delete');
    if (lastDelete == null || lastDelete.isBefore(today)) {
      var temp = List.from(tasksList);
      for (int i = 0; i < tasksList.length; i++) {
        if (temp[i]['check'] == true) {
          tasksList.remove(temp[i]);
        }
      }
      box.put('last_delete', today);
      db.storeData(tasksList);
    }
  }

  void receiveData() {
    if (taskName.text != '') {
      Map<String, dynamic> data = {
        'label': taskName.text,
        'dueDate': selectedDate,
        'check': false
      };
      tasksList.insert(0, data);
      MiniTool.mapListDateTimeSorter(tasksList, 'dueDate');
      taskName.clear();
    }
  }

  void orderTask() {
    List<dynamic> todaysTasks = [];
    List<dynamic> previousTasks = [];
    List<dynamic> futureTasks = [];
    List<dynamic> completedTasks = [];

    for (int i = 0; i < tasksList.length; i++) {
      DateTime taskDate = tasksList[i]['dueDate'];
      if (tasksList[i]['check'] == true) {
        completedTasks.add(tasksList[i]);
      } else if (MiniTool.isSameDay(taskDate, DateTime.now())) {
        todaysTasks.add(tasksList[i]);
      } else if (taskDate.isBefore(DateTime.now())) {
        previousTasks.add(tasksList[i]);
      } else {
        futureTasks.add(tasksList[i]);
      }
    }

    orderedList =
        mergeTask([todaysTasks, previousTasks, futureTasks, completedTasks]);
  }

  List<dynamic> mergeTask(List<dynamic> nestedList) {
    List<dynamic> ls = [];
    for (int i = 0; i < nestedList.length; i++) {
      if (nestedList[i].isNotEmpty) {
        ls.add(subNames[i]);
        ls.addAll(nestedList[i]);
      }
    }
    return ls;
  }

  List<dynamic> displayList() {
    return orderedList;
  }

  bool popUpClicked(value, data) {
    removeTask(data);
    if (value == 0) {
      return false;
    } else {
      taskName.text = data['label'];
      selectedDate = data['dueDate'];
      return true;
    }
  }

  void removeTask(task) {
    tasksList.remove(task);
    updateBoxData();
  }

  void updateBoxData() {
    db.storeData(tasksList);
  }
}
