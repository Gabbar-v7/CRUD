// ignore_for_file: non_constant_identifier_names

import 'package:CRUD/logic/counter.dart';
import 'package:CRUD/subpages/add_counter.dart';
import 'package:CRUD/universal/styles.dart';
import 'package:CRUD/utils/mini_tools.dart';
import 'package:flutter/material.dart';

class CounterPage extends StatefulWidget {
  const CounterPage({super.key});

  @override
  State<CounterPage> createState() => _CounterPage();
}

class _CounterPage extends State<CounterPage> {
  late Styles appStyle;
  CounterLogic logic = CounterLogic();
  late List displayCounters;

  updateData() {
    setState(() {
      logic.counters;
    });
  }

  Padding Tile(Data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: appStyle.tileBox(
          _numberOfDays(Data),
          Data['label'],
          '${Data['startDate'].day}/${Data['startDate'].month}/${Data['startDate'].year}',
          _moreOption(Data)),
    );
  }

  Padding _numberOfDays(Data) => Padding(
        padding: const EdgeInsets.only(left: 13.0),
        child: Text(
          '${logic.dayDiff(DateTime.now(), Data['startDate'])}',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple.shade200),
        ),
      );

  Padding _moreOption(Data) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
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
          } else {
            updateData();
            MiniTool.pushPage(context, const AddCounter());
          }
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
            padding: const EdgeInsets.only(left: 7.0),
            child: Text(label),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    appStyle = Styles(context);
    displayCounters = logic.counters;

    return Scaffold(
      appBar: appStyle.appBar(context, 'Counter'),
      body: ListView.builder(
          itemCount: displayCounters.length,
          itemBuilder: (context, index) {
            return Tile(displayCounters[index]);
          }),
      floatingActionButton: appStyle.floatingButton(Icons.add, () {
        logic.start = MiniTool.justDate(DateTime.now());
        logic.label.clear();
        MiniTool.pushPage(context, const AddCounter());
      }),
    );
  }
}
