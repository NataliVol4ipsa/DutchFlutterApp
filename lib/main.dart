import 'dart:ui';

import 'package:dutch_app/domain/dependency_injections.dart';
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/repositories/settings_repository.dart';
import 'package:dutch_app/core/local_db/seed/db_seed.dart';
import 'package:dutch_app/pages/dependency_injections.dart';
import 'package:dutch_app/pages/exercises_selector/exercises_selector_page.dart';
import 'package:dutch_app/pages/settings/settings_page.dart';
import 'package:dutch_app/pages/word_collections/word_collections_list_page.dart';
import 'package:dutch_app/pages/word_editor/word_editor_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/local_db/dependency_injections.dart';
import 'pages/home_page.dart';

// ctrl + shift + p: launch command line
// win + end: to launch emulator (custom binding)
// shift + alt + f: format document
// flutter pub add xxx - install package xxx
// flutter pub run build_runner build - generate db tables .g.dart
// ctrl + shift + u: open bottom panel with output, debug console etc

//todo is notifier for db changes really needed?

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DbContext.initialize();
  await seedDatabaseAsync();

  DarkThemeToggledNotifier darkThemeNotifier = await _initializeThemeSettings();

  runApp(
    MultiProvider(
      providers: [
        ...databaseProviders(),
        ...notifierProviders(),
        ...serviceProviders(),
        ...coordinatorProviders(),
        ChangeNotifierProvider(create: (_) => darkThemeNotifier),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DarkThemeToggledNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(scheme: FlexScheme.amber),
          darkTheme: FlexThemeData.dark(
            scheme: FlexScheme.amber,
            appBarStyle: FlexAppBarStyle.material,
            appBarElevation: 1,
          ),
          themeMode: themeNotifier.currentTheme,
          home: const HomePage(),
          routes: {
            '/home': (context) => const HomePage(),
            '/settings': (context) => const SettingsPage(),
            '/wordeditor': (context) => const WordEditorPage(),
            '/wordcollections': (context) => const WordCollectionsListPage(),
            '/exerciseselector': (context) => const ExercisesSelectorPage(),
          },
        );
      },
    );
  }
}

// Load theme settings from db
Future<DarkThemeToggledNotifier> _initializeThemeSettings() async {
  final settingsRepository = SettingsRepository();
  final settingsService = SettingsService(
    settingsRepository: settingsRepository,
  );
  final platformBrightness = PlatformDispatcher.instance.platformBrightness;
  final darkThemeNotifier = DarkThemeToggledNotifier();
  await darkThemeNotifier.loadInitialTheme(settingsService, platformBrightness);
  return darkThemeNotifier;
}
