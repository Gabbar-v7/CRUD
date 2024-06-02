import 'package:CRUD/utils/mini_tools.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoLogic {
  late Box<Map> taskBox;
  late Box box;
  late List<dynamic> orderedTasks;
  late List<dynamic> displayTasks;
  List<String> category = [' Today',' Previous',  ' Future', ' Completed'];

  DateTime today = MiniTool.justDate(DateTime.now());

  ToDoLogic(this.displayTasks, Function updateUi) {
    setVariables(updateUi);
  }

  void setVariables(Function updateUi) async {
    taskBox = await Hive.openBox<Map>('todo_box');
    box = Hive.box('user_data');
    orderedTasks = taskBox.values.toList();
    orderedTasks.sort((a, b) =>
        (a['dueDate'] as DateTime).compareTo(b['dueDate'] as DateTime));
    List completedTasks = orderTask();
    if (!MiniTool.isSameDay(box.get('last_task_delete', defaultValue: DateTime(2000)), today)){
      for ( Map task in completedTasks){
        taskBox.delete(task['key']);
      }
      box.put('last_task_delete', today);
    }
    updateUi();
  }

  List orderTask() {
    List<dynamic> todaysTasks = [];
    List<dynamic> previousTasks = [];
    List<dynamic> futureTasks = [];
    List<dynamic> completedTasks = [];
    for (Map task in orderedTasks) {
      DateTime taskDate = task['dueDate'];
      if (task['isDone'] == true) {
        completedTasks.add(task);
      } else if (MiniTool.isSameDay(taskDate, today)) {
        todaysTasks.add(task);
      } else if (taskDate.isBefore(today)) {
        previousTasks.add(task);
      } else {
        futureTasks.add(task);
      }
    }
    List nestedList=[todaysTasks, previousTasks, futureTasks,completedTasks];
    displayTasks.clear();
    for (int i = 0; i < nestedList.length; i++) {
      if (nestedList[i].isNotEmpty) {
        displayTasks.add(category[i]);
        displayTasks.addAll(nestedList[i]);
      }}
    return completedTasks;
  }

  void updateTask(Map task){
    taskBox.put(task['key'], task);
  }

}
