// ignore_for_file: prefer_const_constructors

import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/local_db/repositories/word_collections_repository.dart';
import 'package:first_project/pages/learning_models_selector/learning_modes_selector_page.dart';
import 'package:first_project/pages/learning_flow/learning_task_answered_notifier.dart';
import 'package:first_project/pages/word_collections/word_collections_list_page.dart';
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
      Provider<WordsRepository>(create: (_) => WordsRepository()),
      Provider<WordCollectionsRepository>(
          create: (_) => WordCollectionsRepository()),
      ChangeNotifierProvider(create: (_) => LearningTaskAnsweredNotifier()),
    ], child: MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorSchemeSeed: Color.fromARGB(255, 0, 255, 213),
          brightness: Brightness.light,
          useMaterial3: true,
        ),
        home: HomePage(),
        routes: {
          '/home': (context) => HomePage(),
          '/newword': (context) => WordEditorPage(),
          '/wordlist': (context) => WordListPage(),
          '/wordcollections': (context) => WordCollectionsListPage(),
          '/learningmodesselector': (context) => LearningModesSelectorPage(),
        });
  }
}
