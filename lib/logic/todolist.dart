import 'package:CRUD/utils/mini_tools.dart';
import 'package:CRUD/utils/user_data_manager.dart';
import 'package:flutter/material.dart';

class ToDoLogic {
  // Hive
  UserDataManager db = UserDataManager('todo_tasks');

  //Constructor
  ToDoLogic() {
    tasksList = db.getData();
    orderTask();
  }

//Screen comunicator variable
  TextEditingController taskName = TextEditingController();
  DateTime selectedDate = DateTime.now();

//Task data variable
  late List<dynamic> tasksList = [];
  List<String> subNames = ['Today', 'Pending', 'Future', 'Completed'];
  List<dynamic> orderedList = [];

  void setCurrentDate() {
    selectedDate = DateTime.now();
  }

  void receiveData() {
    if (taskName.text != '') {
      Map<String, dynamic> data = {
        'label': taskName.text,
        'dueDate': selectedDate,
        'check': false
      };
      tasksList.insert(0, data);
      MiniTool().mapListDateTimeSorter(tasksList, 'dueDate');
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
      } else if (MiniTool().isSameDay(taskDate, DateTime.now())) {
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

  void removeTask(task) {
    tasksList.remove(task);
    updateBoxData();
  }

  void updateBoxData() {
    db.storeData(tasksList);
  }
}
