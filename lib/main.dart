// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'pages/todolist_page.dart';

// ctrl + shift + p: launch command line
// win + end: to launch emulator (custom binding)
// shift + alt + f: format document

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ToDoListPage(),
        theme: ThemeData(primarySwatch: Colors.yellow));
  }
}
