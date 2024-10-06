// ignore_for_file: prefer_const_constructors

import 'package:first_project/models/db_context.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/new_word_input_page.dart';

// ctrl + shift + p: launch command line
// win + end: to launch emulator (custom binding)
// shift + alt + f: format document

//todo is notifier for db changes really needed?
//todo floating action button bottom right at list of words to add new word - 3:29:47 of guide

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbContext.initialize();
  runApp(
    MultiProvider(
      providers: [
        Provider<DbContext>(
            create: (_) => DbContext()), // Ensure DbContext is provided
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false, home: NewWordInputPage());
  }
}
