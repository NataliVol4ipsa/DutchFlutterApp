import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/pages/dependency_injections.dart';
import 'package:first_project/pages/exercises_selector/exercises_selector_page.dart';
import 'package:first_project/pages/word_collections/word_collections_list_page.dart';
import 'package:first_project/pages/word_list/word_list_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'local_db/dependency_injections.dart';
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
      ...databaseProviders(),
      ...notifierProviders(),
    ], child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //var scheme = FlexScheme.amber;
    //var scheme = FlexScheme.espresso;
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: FlexThemeData.light(scheme: FlexScheme.amber),
        darkTheme: FlexThemeData.dark(
          scheme: FlexScheme.amber,
          appBarStyle: FlexAppBarStyle.material,
          appBarElevation: 1,
        ),
        themeMode: ThemeMode.light,
        // theme: ThemeData(
        //   // Color.fromARGB(255, 0, 255, 213),
        //   // Color.fromARGB(255, 54, 94, 2),
        //   //colorSchemeSeed: const Color.fromARGB(255, 54, 94, 2),
        //   brightness: Brightness.light,
        //   useMaterial3: true,
        // ),
        home: const HomePage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/newword': (context) => const WordEditorPage(),
          '/wordlist': (context) => const WordListPage(),
          '/wordcollections': (context) => const WordCollectionsListPage(),
          '/exercisesselector': (context) => const ExercisesSelectorPage(),
        });
  }
}
