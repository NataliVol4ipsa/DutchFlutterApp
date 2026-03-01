/// Integration test: word-list selection → Quick Practice
///
/// ## What this tests
/// The end-to-end flow where a user selects words from the word-collection
/// multiselect view and starts a Quick Practice session for only those words.
///
///   1. Navigate to the Collections page (word list).
///   2. Long-press the "Default collection" header → enters multiselect mode
///      and selects all 25 words (5 new + 20 practiced) at once.
///   3. Tap the "Quick Practice" button in the multiselect bottom bar.
///   4. Pre-session word list ("Today's Words") appears.
///   5. Assert header chips: "25 words", "5 new", "20 review".
///   6. Assert exactly 5 NEW badges are visible.
///
/// ## Settings
///   Default values (no DB override needed):
///     newWordsPerSession    = 5
///     repetitionsPerSession = 20
///     showPreSessionWordList = true
///     useAnkiMode           = false
///
/// ## DB setup
///   All words go into the single "Default collection":
///     10 words with NO DbWordProgress  (brand-new)   → ABOVE the 5-word quota
///     30 words with an OVERDUE DbWordProgress each   → ABOVE the 20-word quota
///
/// ## Bug exposed
///   buildSessionFromWordsAsync passes ALL selected words directly to
///   LearningSessionManager without applying the newWordsPerSession /
///   repetitionsPerSession session quotas from settings.  When the user
///   selects 40 words (10 new + 30 practiced) the buggy code produces a
///   session with 40 words instead of the expected 25 (5 new + 20 review).
///   The test therefore fails on the 'words' / 'new' / 'review' chip
///   assertions until the quota is applied in buildSessionFromWordsAsync.
library;
// ignore_for_file: avoid_relative_lib_imports

import 'dart:io';

import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/dependency_injections.dart' as db_di;
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/entities/db_settings.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/domain/dependency_injections.dart' as domain_di;
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/dependency_injections.dart' as pages_di;
import 'package:dutch_app/pages/exercises_selector/exercises_selector_page.dart';
import 'package:dutch_app/pages/home_page.dart';
import 'package:dutch_app/pages/settings/settings_page.dart';
import 'package:dutch_app/pages/word_collections/word_collections_list_page.dart';
import 'package:dutch_app/pages/word_editor/word_editor_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

// ── App builder ───────────────────────────────────────────────────────────────

Widget _buildApp() {
  return MultiProvider(
    providers: [
      ...db_di.databaseProviders(),
      ...domain_di.serviceProviders(),
      ...pages_di.notifierProviders(),
      ...pages_di.coordinatorProviders(),
      ChangeNotifierProvider<DarkThemeToggledNotifier>(
        create: (_) => DarkThemeToggledNotifier(),
      ),
    ],
    child: Consumer<DarkThemeToggledNotifier>(
      builder: (context, themeNotifier, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: FlexThemeData.light(scheme: FlexScheme.amber),
          darkTheme: FlexThemeData.dark(scheme: FlexScheme.amber),
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
    ),
  );
}

// ── DB seed helpers ───────────────────────────────────────────────────────────

/// Inserts a word with NO progress record into the default collection.
/// [getNewWordsAsync] will return this word (filter: progressIsEmpty).
Future<void> _seedNewWord(String dutch, String english) async {
  final isar = DbContext.isar;

  final dbDutch = DbDutchWord()
    ..word = dutch
    ..audioCode = null;
  final dbEnglish = DbEnglishWord()..word = english;
  final dbWord = DbWord()
    ..type = PartOfSpeech.unspecified
    ..contextExample = null
    ..contextExampleTranslation = null
    ..userNote = null;

  await isar.writeTxn(() async {
    await isar.dbDutchWords.put(dbDutch);
    await isar.dbEnglishWords.put(dbEnglish);
    await isar.dbWords.put(dbWord);

    dbWord.dutchWordLink.value = dbDutch;
    await dbWord.dutchWordLink.save();

    dbWord.englishWordLinks.add(dbEnglish);
    await dbWord.englishWordLinks.save();

    final col = await isar.dbWordCollections
        .filter()
        .nameEqualTo(CollectionPermissionService.defaultCollectionName)
        .findFirst();
    if (col != null) {
      dbWord.collection.value = col;
      await dbWord.collection.save();
    }
  });
}

/// Inserts a word WITH an overdue [DbWordProgress] into the default collection.
/// [getDueProgressAsync] will return this word; it appears as "practiced".
Future<void> _seedPracticedWord(String dutch, String english) async {
  final isar = DbContext.isar;

  final dbDutch = DbDutchWord()
    ..word = dutch
    ..audioCode = null;
  final dbEnglish = DbEnglishWord()..word = english;
  final dbWord = DbWord()
    ..type = PartOfSpeech.unspecified
    ..contextExample = null
    ..contextExampleTranslation = null
    ..userNote = null;

  await isar.writeTxn(() async {
    await isar.dbDutchWords.put(dbDutch);
    await isar.dbEnglishWords.put(dbEnglish);
    await isar.dbWords.put(dbWord);

    dbWord.dutchWordLink.value = dbDutch;
    await dbWord.dutchWordLink.save();

    dbWord.englishWordLinks.add(dbEnglish);
    await dbWord.englishWordLinks.save();

    final col = await isar.dbWordCollections
        .filter()
        .nameEqualTo(CollectionPermissionService.defaultCollectionName)
        .findFirst();
    if (col != null) {
      dbWord.collection.value = col;
      await dbWord.collection.save();
    }

    final progress = DbWordProgress()
      ..exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish
      ..nextReviewDate = DateTime.now().subtract(const Duration(hours: 2))
      ..lastPracticed = DateTime.now().subtract(const Duration(days: 1));
    await isar.dbWordProgress.put(progress);

    progress.word.value = dbWord;
    await progress.word.save();
  });
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('it_wl_quick_practice_');
    DbContext.isar = await Isar.open(
      [
        DbWordSchema,
        DbWordCollectionSchema,
        DbWordProgressSchema,
        DbSettingsSchema,
        DbDutchWordSchema,
        DbEnglishWordSchema,
        DbWordNounDetailsSchema,
        DbWordVerbDetailsSchema,
      ],
      directory: tempDir.path,
      name: 'wl_quick_practice_isar',
    );
    await DbDefaultCollectionSeed.seedAsync();
  });

  tearDown(() async {
    await DbContext.isar.close(deleteFromDisk: true);
    await tempDir.delete(recursive: true);
  });

  testWidgets(
    'Word-list selection Quick Practice — session respects newWordsPerSession and repetitionsPerSession quotas',
    (WidgetTester tester) async {
      // ── Seed data ──────────────────────────────────────────────────────────
      // 10 brand-new words (no progress) — ABOVE the newWordsPerSession=5 quota.
      for (var i = 0; i < 10; i++) {
        await _seedNewWord('nw$i', 'new$i');
      }
      // 30 practiced / overdue words — ABOVE the repetitionsPerSession=20 quota.
      for (var i = 0; i < 30; i++) {
        await _seedPracticedWord('ow$i', 'old$i');
      }
      // 40 words total in the collection; settings cap the session to 5+20=25.
      // Default settings apply: newWordsPerSession=5, repetitionsPerSession=20,
      // showPreSessionWordList=true, useAnkiMode=false.

      // ── Launch app ─────────────────────────────────────────────────────────
      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();
      expect(find.text('Home page'), findsOneWidget);

      // ── Navigate to Collections page ───────────────────────────────────────
      await tester.tap(find.text('Collections'));
      // Give _loadDataAsync (Isar DB reads for all collections + words) time.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      expect(find.text('Words and collections'), findsOneWidget);
      expect(
        find.byType(CircularProgressIndicator),
        findsNothing,
        reason: 'All collections must be loaded before the test proceeds',
      );
      // The "Default collection" header must be visible at the top of the list.
      expect(
        find.text('Default collection'),
        findsOneWidget,
        reason:
            '"Default collection" is the only collection in the DB and must be visible',
      );

      // ── Enter multiselect by long-pressing the collection header ───────────
      // _longPressCollection → _toggleCheckboxMode() +
      // toggleIsSelectedCollectionAndWords() → isSelected=true on the
      // collection AND all 25 word models.
      await tester.longPress(find.text('Default collection'));
      await tester.pump(const Duration(seconds: 1));
      await tester.pumpAndSettle();

      // App bar should now show the selection count: 40 words selected.
      expect(
        find.text('Selected 40 words'),
        findsOneWidget,
        reason:
            'All 40 words must be selected after long-pressing the collection header',
      );

      // ── Tap "Quick Practice" in the multiselect bottom bar ─────────────────
      await tester.tap(find.text('Quick Practice'));
      // Allow buildSessionFromWordsAsync (reads settings from Isar) and
      // PreSessionWordListPage._loadPracticedWordsAsync to complete.
      await tester.pump(const Duration(seconds: 3));
      await tester.pumpAndSettle();

      // ── Assert: pre-session word list page ────────────────────────────────
      expect(
        find.text("Today's Words"),
        findsOneWidget,
        reason:
            'showPreSessionWordList=true → pre-session list must appear instead of going directly to session',
      );

      // Header chips must reflect the SESSION limits, not the raw selection.
      // newWordsPerSession=5 and repetitionsPerSession=20 cap the total to 25.
      expect(
        find.text('25 words'),
        findsOneWidget,
        reason:
            'newWordsPerSession=5 + repetitionsPerSession=20 = 25 words max; '
            'all 40 selected words must NOT all appear in the session',
      );
      expect(
        find.text('5 new'),
        findsOneWidget,
        reason:
            'Only 5 of the 10 new words should be included (newWordsPerSession=5 cap)',
      );
      expect(
        find.text('20 review'),
        findsOneWidget,
        reason:
            'Only 20 of the 30 practiced words should be included (repetitionsPerSession=20 cap)',
      );

      // Exactly 5 NEW badges visible — one per capped new-word tile.
      expect(
        find.text('NEW'),
        findsNWidgets(5),
        reason:
            'Only 5 new words should appear; if 10 NEW badges show, '
            'newWordsPerSession cap is not being applied',
      );
    },
  );
}
