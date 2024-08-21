import 'package:CRUD/utils/styles.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appStyle.appBar('Pomodoro Timer'),
    );
  }
}
