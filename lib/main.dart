// ignore_for_file: prefer_const_constructors

import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/pages/learning_modes/learning_modes_page.dart';
import 'package:first_project/pages/word_list/word_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'local_db/repositories/words_repository.dart';
import 'pages/words_editor/word_editor_page.dart';
import 'pages/home_page.dart';

// ctrl + shift + p: launch command line
// win + end: to launch emulator (custom binding)
// shift + alt + f: format document
// flutter pub add - install package

//todo is notifier for db changes really needed?
//todo floating action button bottom right at list of words to add new word - 3:29:47 of guide

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbContext.initialize();
  runApp(
    MultiProvider(providers: [
      Provider<DbContext>(create: (_) => DbContext()),
      ProxyProvider<DbContext, WordsRepository>(
        update: (_, dbContext, __) => WordsRepository(dbContext: dbContext),
      ),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
        routes: {
          '/home': (context) => HomePage(),
          '/newword': (context) => WordEditorPage(),
          '/wordlist': (context) => WordListPage(),
          '/practice': (context) => LearningModesPage(),
        });
  }
}
