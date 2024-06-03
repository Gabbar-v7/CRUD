
import 'package:CRUD/logic/todo_list.dart';
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
  bool initialized=false;
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
      if (!initialized){appStyle;
      logic = ToDoLogic(
          displayTasks,
          () => setState(() {
                displayTasks;
              }));
    initialized=true;}
  }

  @override
  void dispose(){
    super.dispose();
    logic.worker.end();
  }

  Widget tile(dynamic content) {
    if (!logic.category.contains(content)) {
      return taskTile(content);
    } else {
      return categoryTile(content as String);
    }
  }

  Widget categoryTile(String content) {
    return Text(
      content,
      style: const TextStyle(
          color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  GestureDetector taskTile(Map task) {
    return GestureDetector(
        key: ValueKey<String>(task['key']),
        // onLongPress: () => ,
        onHorizontalDragEnd: (detail) {
          if (detail.primaryVelocity! > 0) {
            task['isDone'] = !task['isDone'];
            logic.worker.crudIsolate('update', task);
          } else if (detail.primaryVelocity! < 0) {
            null;
            // logic.removeTask(Data);
            // updateData();
          }
        },
        child: ListTile(
            visualDensity: VisualDensity.compact,
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
                  task['isDone'] = value!;
                  logic.worker.crudIsolate('update', task);
                }),
            title: Text(
              task['title'],
              style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis),
            ),
            trailing: Text(
              '${task['dueDate'].day}/${task['dueDate'].month}',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            )));
  }


  StatefulBuilder taskModalSheet() {
    final TextEditingController controller =TextEditingController();
    return  StatefulBuilder(

      builder: (context, setstate) => 
        Column(
        children: [
          TextField(
            controller: controller,
      ),
        ],
    ),
      );
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
            () => showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 39, 43, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                context: context,
                builder: (context) => taskModalSheet())));
  }
}
