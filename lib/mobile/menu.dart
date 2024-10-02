import 'package:CRUD/mobile/coming_soon.dart';
import 'package:CRUD/mobile/pomodoro_timer.dart';
import 'package:CRUD/mobile/todo_list.dart';
import 'package:flutter/material.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _Menu();
}

class _Menu extends State<Menu> {
  int currentIndex = 0;
  List<Widget> pages = const [
    ToDoPage(),
    PomodoroTimer(),
    ComingSoon(),
    ComingSoon()
  ];
  late Widget currentPage = pages[currentIndex];

  @override
  void initState() {
    super.initState();
    currentPage;
  }

  BottomNavigationBar navigationBar() {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (int index) => setState(() {
        currentIndex = index;
      }),
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.checklist), label: "ToDo-List"),
        BottomNavigationBarItem(
            icon: Icon(Icons.alarm_outlined), label: "Pomodoro Timer"),
        BottomNavigationBarItem(
            icon: Icon(Icons.rtt),
            label:
                "Notes"), //edit_square  rtt spellcheck_sharp summarize_outlined wifi_protected_setup
        BottomNavigationBarItem(
            icon: Icon(Icons.bubble_chart_outlined), label: "More")
      ],
      elevation: 0,
      fixedColor: Colors.white,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: pages,
      ),
      bottomNavigationBar: navigationBar(),
    );
  }
}
