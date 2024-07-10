import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:CRUD/utils/mini_tools.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoLogic {
  late Worker worker;
  late List<dynamic> displayTasks;
  List<String> category = [' Today', ' Previous', 'Future', ' Completed'];
  // List<String> operation = ['create', 'update', 'delete'];

  DateTime today = MiniTool.justDate(DateTime.now());

  ToDoLogic(this.displayTasks, Function updateUi) {
    worker = Worker(displayTasks, updateUi);
  }
}

class Worker {
  late final Isolate isolate;
  Completer<void> isolateReady = Completer<void>();
  late SendPort sendPort;
  late String path;
  Box box = Hive.box('user_data');
  List<dynamic> displayTasks;
  Function updateUi;

  Worker(this.displayTasks, this.updateUi) {
    try {
      spawn();
    } catch (error) {
      null;
    }
  }

  void spawn() async {
    Directory dir = await getApplicationDocumentsDirectory();
    path = dir.path;
    ReceivePort receivePort = ReceivePort();

    receivePort.listen(_responsesFromIsolate);

    isolate = await Isolate.spawn(_remoteIsolate, receivePort.sendPort);
  }

  void crudIsolate(String type, Map task) {
    sendPort.send([type, task]);
  }

  void end() {
    try {
      isolate.kill();
    } catch (error) {
      null;
    }
  }

  void _responsesFromIsolate(dynamic message) {
    if (message is List) {
      displayTasks.clear();
      displayTasks.addAll(message);
      updateUi();
    } else if (message is SendPort) {
      sendPort = message;
      isolateReady.complete();

      DateTime today = DateTime.now();
      if (!MiniTool.isSameDay(today, box.get('last_task_delete',defaultValue: DateTime(2020)))) {
        sendPort.send({'path': path, 'deleteAll': true});
        box.put('last_task_delete', today);
      } else {
        sendPort.send({'path': path, 'deleteAll': false});
      }
    }
  }

  static void _remoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    late Box taskBox;
    late List<dynamic> orderedTasks;
    late List completedTasks;
    late List<dynamic> displayTasks = [];

    receivePort.listen((dynamic message) async {
      if (message is List) {
        String operation = message[0];
        Map task = message[1];
        if (operation == 'create') {
          task['key'] = DateTime.now().toString();
          taskBox.put(task['key'], task);
          orderedTasks.add(task);
          orderTask(orderedTasks, displayTasks);
          sendPort.send(displayTasks);
        } else if (operation == 'update') {
          orderedTasks[orderedTasks.indexOf(taskBox.get(task['key']))] = task;
          taskBox.put(task['key'], task);
          orderTask(orderedTasks, displayTasks);
          sendPort.send(displayTasks);
        } else if (operation == 'delete') {
          orderedTasks.removeAt(orderedTasks.indexOf(taskBox.get(task['key'])));
          taskBox.delete(task['key']);
          orderTask(orderedTasks, displayTasks);
          sendPort.send(displayTasks);
        }
      } else if (message is Map) {
        Hive.init(message['path']);
        taskBox = await Hive.openBox<Map>('todo_box');
        orderedTasks = taskBox.values.toList();
        orderedTasks.sort(
          (a, b) => a['dueDate'].compareTo(b['dueDate']),
        );
        completedTasks = orderTask(orderedTasks, displayTasks);
        if (message['deleteAll']) {
          for (Map task in completedTasks) {
          displayTasks.remove(task);
          orderedTasks.remove(task);
            taskBox.delete(task['key']);
          }
          displayTasks.remove(' Completed');
        } 
          sendPort.send(displayTasks);
      }
    });
  }

  static List orderTask(List orderedTasks, List displayTasks) {
    List<dynamic> todaysTasks = [];
    List<dynamic> previousTasks = [];
    List<dynamic> futureTasks = [];
    List<dynamic> completedTasks = [];
    List<String> category = [' Today', ' Previous', 'Future', ' Completed'];

    DateTime today = MiniTool.justDate(DateTime.now());

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
    List nestedList = [todaysTasks, previousTasks, futureTasks, completedTasks];
    displayTasks.clear();
    for (int i = 0; i < nestedList.length; i++) {
      if (nestedList[i].isNotEmpty) {
        displayTasks.add(category[i]);
        displayTasks.addAll(nestedList[i]);
      }
    }
    return completedTasks;
  }
}
