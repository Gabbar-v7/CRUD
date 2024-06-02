import 'package:CRUD/logic/todo_list.dart';
import 'package:CRUD/pages/test.dart';
import 'package:CRUD/utils/nav_manager.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  late Styles appStyle = Styles(context);
  List<dynamic> displayTasks = [];
  late ToDoLogic logic;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appStyle;
    logic = ToDoLogic(
        displayTasks,
        () => setState(() {
          displayTasks;
            }));
  }

  Widget tile(dynamic content) {
    if (!logic.category.contains(content)) {
      return taskTile(content);
    } else {
      return categoryTile(content as String);
    }
  }

  Widget categoryTile(String content) {
    return Text(content, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),);
  }

  GestureDetector taskTile(Map task) {
    return GestureDetector(
      key:ValueKey<String>(task['key']) ,
      // onLongPress: () => ,
        onHorizontalDragEnd: (detail) {
          if (detail.primaryVelocity! > 0) {
            setState(() {
              task['isDone'] = !task['isDone'];
            });
            logic.updateTask(task);
          } else if (detail.primaryVelocity! < 0) {
            null;
            // logic.removeTask(Data);
            // updateData();
          }
        },
        child: ListTile(visualDensity: VisualDensity.compact,
        horizontalTitleGap: 7,
          tileColor: const Color.fromARGB(
            225,
            39,
            43,
            48,
          ),
          
          leading: Checkbox(
            visualDensity: VisualDensity.compact,
            activeColor: Colors.deepPurple.shade300,
              value: task['isDone'],
              onChanged: (bool? value) {
                setState(() {
                  task['isDone'] = value!;
                });
                logic.updateTask(task);
              }),
          title: Text(
            task['title'],
            style: const TextStyle( fontSize: 16,color: Colors.white, fontWeight: FontWeight.w500,
            
            overflow: TextOverflow.ellipsis),
          ),
          trailing: Text('${task['dueDate'].day}/${task['dueDate'].month}',
          style: const TextStyle(fontSize: 14,color: Colors.grey),)
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appStyle.appBar('To-Do List'),
      body: appStyle.pageBorder(ListView.separated(
          itemCount: displayTasks.length,
          separatorBuilder: (context, index) => const Gap(10),
          itemBuilder: (context, index) => tile(displayTasks[index]))),
      floatingActionButton: appStyle.floatButton(
          const Icon(
            Icons.add,
            size: 25,
            color: Colors.white,
          ),
          ()=> NavManager.pushPage(context, const TestPage())),
    );
  }
}

Map createtask(){
  var key = DateTime.now().toString();
  return {'title': 'ahabbhahushyegwghvabvdgysgfy huayub', 'dueDate': DateTime.now(), 'isDone': false, 'key': key};
}