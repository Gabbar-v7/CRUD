import 'dart:async';
import 'dart:io';
import 'dart:isolate';
import 'package:path_provider/path_provider.dart';
import 'package:CRUD/utils/mini_tools.dart';
import 'package:hive_flutter/hive_flutter.dart';

class ToDoLogic {
  late Worker worker ;
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
  Completer<void> isolateReady=Completer<void>();
  late SendPort sendPort;
  late String path;
  List<dynamic> displayTasks;
  Function updateUi ;

  Worker(this.displayTasks, this.updateUi){
  spawn();
  }

  void spawn()async{
    Directory dir = await getApplicationDocumentsDirectory();
     path = dir.path;
    ReceivePort receivePort = ReceivePort();

    receivePort.listen(_responsesFromIsolate);

     isolate = await Isolate.spawn(_remoteIsolate, receivePort.sendPort);
  }

  void crudIsolate(String type, Map task){
    sendPort.send([type, task]);
  }

  void end(){
    isolate.kill();
  }

  void _responsesFromIsolate(dynamic message) {
   if (message is List) {
    displayTasks.clear();
    displayTasks.addAll(message);
    updateUi();
  } else if (message is SendPort) {
    sendPort=message;
    isolateReady.complete();
    sendPort.send(path);
    }
  }

  static void _remoteIsolate(SendPort sendPort) {
    final receivePort = ReceivePort();
    sendPort.send(receivePort.sendPort);
    late Box taskBox;
  late List<dynamic> orderedTasks;
  late List<dynamic> displayTasks=[];

    receivePort.listen((dynamic message) async {
    if (message is List) {
      String operation = message[0];
      Map task = message[1];

      if (operation=='create'){
        taskBox.put(task['key'], task);
        orderedTasks.add(task);
        orderTask(orderedTasks, displayTasks);
        sendPort.send(displayTasks);
      }
      else if (operation == 'update'){
        orderedTasks[orderedTasks.indexOf(taskBox.get(task['key']))]=task;
        taskBox.put(task['key'], task);
        orderTask(orderedTasks, displayTasks);
        sendPort.send(displayTasks);
      }
      else if(message[0]=='delete'){
        orderedTasks.remove(task);
        taskBox.delete(task['key']);
        orderTask(orderedTasks, displayTasks);
        sendPort.send(displayTasks);
      }
    }
    else if(message is String){
      Hive.init(message);
      taskBox =await Hive.openBox('todo_box');
      orderedTasks = taskBox.values.toList();
      orderTask(orderedTasks, displayTasks);
      sendPort.send(displayTasks);
    }
  });
  }

static void orderTask(List orderedTasks, List displayTasks) {
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
    List nestedList=[todaysTasks, previousTasks, futureTasks,completedTasks];
    displayTasks.clear();
    for (int i = 0; i < nestedList.length; i++) {
      if (nestedList[i].isNotEmpty) {
        displayTasks.add(category[i]);
        displayTasks.addAll(nestedList[i]);
      }}
    
  }

}
