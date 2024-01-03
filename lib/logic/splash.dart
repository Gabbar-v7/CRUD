import 'dart:async';
import 'package:CRUD/pages/todolist.dart';
import 'package:flutter/material.dart';

void changePage(context) {
  Timer(const Duration(milliseconds: 400), () {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => ToDoPage()));
  });
}
