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

  Padding Tile(Data) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: appStyle.tileBox(
          _numberOfDays(Data),
          Data['label'],
          '${Data['startDate'].day}/${Data['startDate'].month}/${Data['startDate'].year}',
          const Text('data')),
    );
  }

  Padding _numberOfDays(Data) => Padding(
        padding: const EdgeInsets.only(left: 13.0),
        child: Text(
          '${logic.dayDiff(Data['startDate'], DateTime.now())}',
          style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple.shade200),
        ),
      );

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
        MiniTool.pushPage(context, const AddCounter());
      }),
    );
  }
}
