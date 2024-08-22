// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:CRUD/utils/nav_manager.dart';
import 'package:CRUD/utils/styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class PomodoroTimer extends StatefulWidget {
  const PomodoroTimer({super.key});
  @override
  State<PomodoroTimer> createState() => _PomodoroTimer();
}

class _PomodoroTimer extends State<PomodoroTimer> {
  late Styles appStyle = Styles(context);
  bool initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!initialized) {
      appStyle;
      initialized = true;
    }
  }

  Column layout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(
          width: double.infinity,
        ),
        CircularPercentIndicator(
          key: ValueKey('Progress Bar'),
          animation: true,
          animationDuration: 600,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.black38,
          radius: 130.0,
          lineWidth: 30,
          percent: 0.4,
          center: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.transparent),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white)),
            child: Text(
              "30:00",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
            ),
          ),
        ),
        const Gap(70),
        Text(
          'Focus Mode',
          style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        const Gap(20),
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.play_arrow_rounded, // pause,
              color: Colors.white,
              size: 60,
            )),
        Text(
          'Resume',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appStyle.appBar('Pomodoro Timer'),
      body: layout(),
      floatingActionButton: appStyle.floatButton(
          Icon(
            Icons.refresh_rounded,
            size: 30,
          ),
          () => showDialog(
                //if set to true allow to close popup by tapping out of the popup
                barrierDismissible: true,
                barrierColor: Color.fromARGB(115, 47, 44, 38),
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: Text(
                    "Confirm Reset",
                  ),
                  actions: <Widget>[
                    ElevatedButton(
                      onPressed: () => NavManager.popPage(context),
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        elevation: WidgetStateProperty.all<double>(0),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text(
                        "Yes",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ElevatedButton(
                      style: ButtonStyle(
                        splashFactory: NoSplash.splashFactory,
                        overlayColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                        elevation: WidgetStateProperty.all<double>(0),
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.transparent),
                      ),
                      child: Text(
                        "No",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                      onPressed: () => NavManager.popPage(context),
                    )
                  ],
                ),
              )),
    );
  }
}
