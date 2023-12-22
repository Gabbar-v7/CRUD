import 'package:CRUD/utils/mini_tools.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoLogic {
  // Hive
  Box box = Hive.box<List<dynamic>>('test');
  String key = 'todo';
  List<dynamic> GetData = [];

  void giveData() async {
    // if (!box.isOpen) await initHive(); // Ensure box is open
    if (box.get('test') != null) {
      GetData = box.get('test');
    }
  }

  void storeData(data) {
    // if (!box.isOpen) await initHive(); // Ensure box is open
    box.put('test', data);
  }

  //Constructor
  ToDoLogic() {
    giveData();
    tasksList = GetData;
    orderTask();
  }

//Screen comunicator variable
  TextEditingController taskName = TextEditingController();
  DateTime selectedDate = DateTime.now();

//Task data variable
  late List<dynamic> tasksList = [];
  List<String> subNames = ['Today...', 'Pending...', 'Future...', 'Completed'];
  List<dynamic> orderedList = [];

  void setCurrentDate() {
    selectedDate = DateTime.now();
  }

  void receiveData() {
    if (taskName.text != '') {
      Map<String, dynamic> Data = {
        'label': taskName.text,
        'dueDate': selectedDate,
        'check': false
      };
      tasksList.add(Data);
      storeData(tasksList);
      orderTask();
    }
  }

  void orderTask() {
    MiniTool().mapListDateTimeSorter(tasksList, 'dueDate');

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

    orderedList = [
      subNames[0],
      ...todaysTasks,
      subNames[1],
      ...previousTasks,
      subNames[2],
      ...futureTasks,
      subNames[3],
      ...completedTasks
    ];
  }

  List<dynamic> displayList() {
    return orderedList;
  }

  void updateBoxData() {
    storeData(tasksList);
  }
}
