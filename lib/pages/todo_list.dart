import 'package:CRUD/logic/todo_list.dart';
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
  late Styles modalStyle = Styles(context);
  final TextEditingController _controller = TextEditingController();
  List<dynamic> displayTasks = [];
  late ToDoLogic logic;
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      appStyle;
      logic = ToDoLogic(
          displayTasks,
          () => setState(() {
                displayTasks;
              }));
      initialized = true;
    }
  }

  @override
  void dispose() {
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
        onLongPress: (){
        _controller.text=task['title'];
         taskModalSheet('Edit', Map<String,dynamic>.from(task));
        }  ,
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

  Future<Widget?> taskModalSheet(String type, Map task) {
    return 
    showModalBottomSheet(
                backgroundColor: const Color.fromARGB(255, 39, 43, 48),
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(30.0)),
                ),
                context: context,
                builder: (context) => 
    StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Gap(7),
          modalStyle
              .appBar(type, backgroundColor: Colors.transparent, actions: [
            Padding(
              padding: const EdgeInsets.only(right: 25.0),
              child: IconButton(
                onPressed: (type == 'Edit') ? () {
                  
                  logic.worker.crudIsolate('delete', task);
                  NavManager.popPage(context);}: null,
                icon: const Icon(Icons.delete, size: 25),
                color: Colors.white,
                disabledColor: Colors.white54,
                enableFeedback: false,
                splashColor: Colors.transparent,
              ),
            )
          ]),
          Padding(
            padding: const EdgeInsets.all(20),
            child: TextField(
              decoration: const InputDecoration(
                  focusColor: Colors.white,
                  labelText: ' Enter task',
                  labelStyle: TextStyle(
                      color: Colors.white70, fontWeight: FontWeight.w400),
                  floatingLabelStyle: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: Colors.white))),
              style: const TextStyle(
                color: Colors.white,
              ),
              controller: _controller,
              cursorColor: Colors.white70,
              textCapitalization: TextCapitalization.sentences,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: logic.today,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if ( picked != task['dueDate']) {
                      setState(() => task['dueDate'] = picked);
                    }
                  },
                  label: Text(
                    '${task['dueDate'].day}/${task['dueDate'].month}',
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 2,
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_rounded),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                        const Color.fromARGB(255, 252, 252, 252)),
                    foregroundColor: WidgetStateProperty.all(Colors.black),
                  ),
                ),
                const Gap(30),
                IconButton(
                    onPressed: () {
                      if(_controller.text.isNotEmpty) {task['title'] = _controller.text;
                      if (type == 'Create') {
                        logic.worker.crudIsolate('create', task);
                      } else {
                        logic.worker.crudIsolate('update', task);
                      }
                      NavManager.popPage(context);}
                    },
                    icon: const Icon(
                      Icons.send,
                      size: 33,
                      color: Colors.white,
                    ))
              ],
            ),
          ),
          const Gap(20),
          Gap(MediaQuery.of(context).viewInsets.bottom),
        ],
      ),
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
            () {
              _controller.text='';
              taskModalSheet('Create', {'title':'','isDone':false, 'dueDate':logic.today});
            } ));
  }
}

// taskModalSheet(
//                     'Create', {'title': '', 'dueDate': logic.today,'isDone':false})