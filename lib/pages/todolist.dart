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
            labelStyle: TextStyle(fontWeight: FontWeight.w600),
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
          padding: EdgeInsets.all(20),
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
        padding: EdgeInsets.all(12),
        onPressed: () {
          selectDueDate(context);
        },
        icon: Row(
          children: <Widget>[
            Icon(
              Icons.calendar_today,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Text(
                  '${logic.selectedDate.day} / ${logic.selectedDate.month}',
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
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
        icon: Icon(
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

  Widget Tile(Data) {
    if (logic.subNames.contains(Data)) {
      return _tense(Data);
    } else {
      return _taskPackage(Data);
    }
  }

  Padding _tense(Data) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: Text(
        Data,
        style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color.fromARGB(216, 0, 255, 242)),
      ),
    );
  }

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
            logic.removeTask(Data);
            updateData();
          }
        },
        child: _taskContainer(Data),
      ),
    );
  }

  Container _taskContainer(Data) {
    return Container(
      width: appStyle.deviceWidth,
      decoration: const BoxDecoration(
          border: Border(left: BorderSide(color: Colors.white, width: 2)),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      child: _taskTile(Data),
    );
  }

  ListTile _taskTile(Data) {
    return ListTile(
      contentPadding: EdgeInsets.only(
        left: 6,
        right: 10,
      ),
      title: Row(
        children: [_taskCheckBox(Data), _taskLabel(Data)],
      ),
      subtitle: _taskDueDate(Data),
      trailing: _moreOptions(Data),
    );
  }

  Checkbox _taskCheckBox(Data) {
    return Checkbox(
        value: Data['check'],
        onChanged: (bool? value) {
          Data['check'] = value!;
          logic.updateBoxData();
          updateData();
        });
  }

  Text _taskLabel(Data) {
    return Text(
      Data['label'],
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.w500,
          decoration:
              Data['check'] ? TextDecoration.lineThrough : TextDecoration.none,
          decorationStyle: TextDecorationStyle.solid,
          decorationColor: Colors.black,
          decorationThickness: 5),
    );
  }

  Padding _taskDueDate(Data) {
    return Padding(
      padding: const EdgeInsets.only(left: 55.0, bottom: 10),
      child: Text(
        '${Data["dueDate"].day}/${Data["dueDate"].month}',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w400),
      ),
    );
  }

  Padding _moreOptions(Data) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: PopupMenuButton(
        elevation: 0,
        padding: EdgeInsets.all(0),
        splashRadius: 0,
        itemBuilder: (BuildContext context) {
          return [
            _popUpMenuItem(0, Icons.delete, 'Delete'),
            _popUpMenuItem(1, Icons.edit, 'Edit'),
          ];
        },
        onSelected: (value) {
          logic.popUpClicked(value, Data);
          updateData();
        },
        child: const Icon(
          Icons.more_vert,
          size: 28,
        ),
      ),
    );
  }

  PopupMenuItem<dynamic> _popUpMenuItem(
      int value, IconData icon, String label) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(icon),
          Padding(
            padding: EdgeInsets.only(left: 7.0),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
          logic.setCurrentDate();
          modalBottomSheet(context);
        },
        child: Icon(
          Icons.add,
          size: 32,
        ),
      ),
    );
  }
}
