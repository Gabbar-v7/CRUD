// ignore_for_file: non_constant_identifier_names

import 'package:CRUD/logic/todolist.dart';
import 'package:CRUD/universal/styles.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_slidable/flutter_slidable.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPage();
}

class _ToDoPage extends State<ToDoPage> {
  //Other page var i.e. class etc.
  late Styles appStyle;
  ToDoLogic logic = ToDoLogic();

//Current page variables
  final FocusNode _textFocus = FocusNode();
  late List<dynamic> displayTasks;
  @override
  late BuildContext context;

  //Frequent functions
  void updateData() {
    setState(() {
      logic.orderTask(); //List are mutable
    });
  }

//ModalBottomSheet
  void modalBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return _modalContainer(context);
        });
  }

  Container _modalContainer(BuildContext context) {
    return Container(
      width: appStyle.deviceWidth - 10,
      padding: EdgeInsets.fromLTRB(
          10, 10, 10, MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [_modalTextField(), _modalPickerRow(context)],
      ),
    );
  }

  Padding _modalTextField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
      child: TextField(
        autofocus: true,
        controller: logic.taskName,
        focusNode: _textFocus,
        decoration: InputDecoration(
            labelText: ' Enter Task: ',
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      ),
    );
  }

  Row _modalPickerRow(context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              _modalDatePicker(context),
              _modalSend(),
            ],
          ),
        )
      ],
    );
  }

  IconButton _modalDatePicker(context) {
    return IconButton(
        padding: const EdgeInsets.all(12),
        onPressed: () {
          selectDueDate(context);
        },
        icon: Row(
          children: <Widget>[
            const Icon(
              Icons.calendar_today,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                  '${logic.selectedDate.day} / ${logic.selectedDate.month}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w600)),
            ),
          ],
        ));
  }

  //DatePicker
  Future<void> selectDueDate(context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: logic.selectedDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(5000));
    if (picked != null && picked != logic.selectedDate) {
      setState(() {
        logic.selectedDate = picked;
      });
      FocusScope.of(context).requestFocus(_textFocus);
    }
  }

  Padding _modalSend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: IconButton(
        onPressed: () {
          _modalSendFunction();
        },
        icon: const Icon(
          Icons.near_me,
          size: 35,
        ),
      ),
    );
  }

  void _modalSendFunction() {
    logic.receiveData();
    updateData();
    logic.updateBoxData();
  }

  //Body data tasks/category
  Widget Tile(Data) {
    if (logic.subNames.contains(Data)) {
      return _tense(Data);
    } else {
      return _taskPackage(Data);
    }
  }

  //Category
  Padding _tense(Data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Text(
        Data,
        style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(216, 0, 255, 242)),
      ),
    );
  }

  //Tasks -> GestureDetector - Container - ListTile(L: null, Title: Row(Checkbox, Text), S: Text, T: PopUpMenuButton)

  Padding _taskPackage(Data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onHorizontalDragEnd: (detail) {
          if (detail.primaryVelocity! > 0) {
            Data['check'] = !Data['check'];
            updateData();
            logic.updateBoxData();
          } else if (detail.primaryVelocity! < 0) {
            null;
            // logic.removeTask(Data);
            // updateData();
          }
        },
        child: _taskContainer(Data),
      ),
    );
  }

  //Box styling
  Container _taskContainer(Data) {
    return Container(
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 2)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: _taskTile(Data),
    );
  }

  //Title Row
  ListTile _taskTile(Data) {
    return ListTile(
      contentPadding: const EdgeInsets.only(
        left: 6,
        right: 10,
      ),
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [_taskCheckBox(Data), _taskLabel(Data)],
      ),
      subtitle: _taskDueDate(Data),
      trailing: _moreOptions(Data),
    );
  }

  //CheckBox
  Checkbox _taskCheckBox(Data) {
    return Checkbox(
        value: Data['check'],
        onChanged: (bool? value) {
          Data['check'] = value!;
          logic.updateBoxData();
          updateData();
        });
  }

  //TaskName
  SizedBox _taskLabel(Data) {
    return SizedBox(
      width: appStyle.deviceWidth * 0.63,
      child: Text(
        Data['label'],
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            fontSize: 21,
            fontWeight: FontWeight.w500,
            decoration: Data['check']
                ? TextDecoration.lineThrough
                : TextDecoration.none,
            decorationStyle: TextDecorationStyle.solid,
            decorationColor: Colors.black,
            decorationThickness: 5),
      ),
    );
  }

  //Subtitle DueDate
  Padding _taskDueDate(Data) {
    return Padding(
      padding: const EdgeInsets.only(left: 55.0, bottom: 10),
      child: Text(
        '${Data["dueDate"].day}/${Data["dueDate"].month}',
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  //Trailing PopUpMenuButton
  Padding _moreOptions(Data) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PopupMenuButton(
        elevation: 0,
        padding: const EdgeInsets.all(0),
        splashRadius: 0,
        itemBuilder: (BuildContext context) {
          return [
            _popUpMenuItem(0, Icons.delete, 'Delete'),
            _popUpMenuItem(1, Icons.edit, 'Edit'),
          ];
        },
        onSelected: (value) {
          if (logic.popUpClicked(value, Data)) {
            updateData();
            modalBottomSheet(context);
          } else {
            updateData();
          }
        },
        child: const Icon(
          Icons.more_vert,
          size: 28,
        ),
      ),
    );
  }

  //PopUpMenu Items resuable function
  PopupMenuItem<dynamic> _popUpMenuItem(
      int value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon),
          Padding(
            padding: const EdgeInsets.only(left: 7.0),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    this.context = context;

    //Getting display tasks
    displayTasks = logic.displayList();

    //Intializing class
    appStyle = Styles(context);

    return Scaffold(
        appBar: appStyle.appBar('To-Do List'),
        body: ListView.builder(
            itemCount: displayTasks.length,
            itemBuilder: (context, index) {
              return Tile(displayTasks[index]);
            }),
        floatingActionButton: _floatingButton());
  }

// FloatingActionButton displays ModalBottomSheet
  Padding _floatingButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 20, bottom: 30),
      child: FloatingActionButton(
        elevation: 0,
        onPressed: () {
          logic.taskName.clear();
          logic.setCurrentDate();
          modalBottomSheet(context);
        },
        child: const Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
