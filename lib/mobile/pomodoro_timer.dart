import 'dart:async';
import 'package:CRUD/logic/pomodoro_timer.dart';
import 'package:CRUD/utils/nav_manager.dart';
import 'package:CRUD/utils/notification_manager.dart';
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
  late PomodoroLogic logic = PomodoroLogic(state);
  Map state = {};
  late Timer timer;
  late int remainingTime;
  late String mode;
  late int totalTime;
  late IconData controlIcon;
  late String controlName;

  @override
  void initState() {
    logic;
    initializeTimer();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      appStyle;
    });
    if (state['remainingTime'] is DateTime) {
      startTimer();
    }
  }

  @override
  void dispose() {
    super.dispose();
    if (state['remainingTime'] is DateTime) {
      timer.cancel();
    }
  }

  void initializeTimer() {
    remainingTime = (state['remainingTime'] is int)
        ? state['remainingTime']
        : state['remainingTime'].difference(DateTime.now()).inSeconds;
    if (remainingTime < 0) {
      state['mode'] =
          (state['mode'] == 'Focus Mode') ? 'Rest Mode' : 'Focus Mode';
      remainingTime = state[state['mode']];
      state['remainingTime'] = remainingTime;
    }
    mode = state['mode'];
    totalTime = state[mode];
    setState(() {
      controlIcon = (state['remainingTime'] is DateTime)
          ? Icons.pause
          : Icons.play_arrow_rounded;
      controlName = (state['remainingTime'] is DateTime) ? 'Pause' : 'Resume';
    });
  }

  void changeState() {
    if (state['remainingTime'] is DateTime) {
      timer.cancel();
      state['remainingTime'] = remainingTime;
      logic.putBox(remainingTime, mode);
      NotificationService.notificationsPlugin.cancel(843);
      initializeTimer();
    } else {
      DateTime endTime = DateTime.now().add(Duration(seconds: remainingTime));
      startTimer();
      NotificationService.scheduleNotification(
          id: 843,
          title: 'Pomodoro Timer',
          body: 'Completed',
          payLoad: 'PomodoroTimer',
          scheduledNotificationDateTime: endTime,
          channelId: 'pomo',
          channelName: 'PomodoroTimer');
      state['remainingTime'] = endTime;
      initializeTimer();
      logic.putBox(state['remainingTime'], mode);
    }
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime > 0) {
        setState(() => remainingTime--);
      } else {
        timer.cancel();
        state['mode'] =
            (state['mode'] == 'Focus Mode') ? 'Rest Mode' : 'Focus Mode';
        state['remainingTime'] = state[state['mode']];
        initializeTimer();
      }
    });
  }

  Column layout() {
    String formattedTime =
        "${(remainingTime ~/ 60).toString().padLeft(2, '0')}:${(remainingTime % 60).toString().padLeft(2, '0')}";

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        const SizedBox(
          width: double.infinity,
        ),
        CircularPercentIndicator(
          key: const ValueKey('Progress Bar'),
          animation: true,
          animateFromLastPercent: true,
          animationDuration: 1000,
          circularStrokeCap: CircularStrokeCap.round,
          progressColor: Colors.black38,
          radius: 130.0,
          lineWidth: 30,
          percent: remainingTime / totalTime,
          center: ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
                splashFactory: NoSplash.splashFactory,
                backgroundColor:
                    WidgetStateProperty.all<Color>(Colors.transparent),
                foregroundColor: WidgetStateProperty.all<Color>(Colors.white)),
            child: Text(
              formattedTime,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
            ),
          ),
        ),
        const Gap(70),
        Text(
          mode,
          style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
        ),
        const Gap(20),
        IconButton(
            onPressed: changeState,
            icon: Icon(
              controlIcon,
              color: Colors.white,
              size: 60,
            )),
        Text(
          controlName,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
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
          const Icon(
            Icons.refresh_rounded,
            size: 30,
          ),
          () => showDialog(
                //if set to true allow to close popup by tapping out of the popup
                barrierDismissible: true,
                barrierColor: const Color.fromARGB(115, 47, 44, 38),
                context: context,
                builder: (BuildContext context) => CupertinoAlertDialog(
                  title: const Text(
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
                      child: const Text(
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
                      child: const Text(
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
