import 'package:hive/hive.dart';

class PomodoroLogic {
  Box box = Hive.box('user_data');
  late Map state;

  PomodoroLogic(this.state) {
    state.addAll(box.get('pomodoro_state', defaultValue: {
      'remainingTime': 1800,
      'mode': 'Focus Mode',
      'Focus Mode': 1800,
      'Rest Mode': 300
    }));
  }

  void putBox(dynamic remainingTime, String mode) {
    box.put('pomodoro_state', {
      'remainingTime': remainingTime,
      'mode': mode,
      'Focus Mode': state['Focus Mode'],
      'Rest Mode': state['Rest Mode']
    });
  }
}
