import 'package:CRUD/logic/counter.dart';
import 'package:CRUD/universal/styles.dart';
import 'package:CRUD/utils/mini_tools.dart';
import 'package:flutter/material.dart';

class AddCounter extends StatefulWidget {
  const AddCounter({super.key});

  @override
  State<AddCounter> createState() => _AddCounter();
}

class _AddCounter extends State<AddCounter> {
  late Styles appStyle;
  CounterLogic logic = CounterLogic();

  Padding _labelRowButton(String name, Widget button) {
    return Padding(
      padding: const EdgeInsets.only(top: 20.0, left: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            name,
            style: const TextStyle(fontSize: 23, fontWeight: FontWeight.w400),
          ),
          button
        ],
      ),
    );
  }

  TextButton _textButton(String buttonLabel, Function() onPress) {
    return TextButton(
        onPressed: onPress,
        child: Text(
          buttonLabel,
          style: const TextStyle(
              fontSize: 18, letterSpacing: 2, color: Colors.white),
        ));
  }

  //DatePicker
  Future<void> selectStartDate(context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: logic.start,
        firstDate: DateTime(2000),
        lastDate: DateTime(5000));
    if (picked != null && picked != logic.start) {
      setState(() {
        logic.start = DateTime(picked.year, picked.month, picked.day,
            logic.start.hour, logic.start.minute);
      });
    }
  }

  //TimePicker
  Future<void> selectStartTime(context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime:
          TimeOfDay(hour: logic.start.hour, minute: logic.start.minute),
    );
    if (picked != null) {
      setState(() {
        logic.start = DateTime(logic.start.year, logic.start.month,
            logic.start.day, picked.hour, picked.minute);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    appStyle = Styles(context);

    return Scaffold(
      appBar: appStyle.appBar(context, 'Add-Counter'),
      body: pageLayout(),
      floatingActionButton: appStyle.floatingButton(Icons.check, () {
        logic.receive(context);
        MiniTool.popPage(context);
      }),
    );
  }

  Widget pageLayout() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appStyle.inputField(
              'Counter Name:', logic.label, logic.labelFocus, 20),
          _labelRowButton(
              'Date:',
              _textButton(
                  '${logic.start.day}/${logic.start.month}/${logic.start.year}',
                  () {
                selectStartDate(context);
              })),
          _labelRowButton(
              'Time:',
              _textButton('${logic.start.hour}:${logic.start.minute}', () {
                selectStartTime(context);
              })),
        ],
      ),
    );
  }
}
