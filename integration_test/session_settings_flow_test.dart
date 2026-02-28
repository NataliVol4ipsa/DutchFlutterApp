/// Integration test: Session settings lock/unlock lifecycle + Quick Practice flows
///
/// ## What this tests
/// Three end-to-end flows exercising session settings and Quick Practice:
///
///   Part A — Settings locked during an active session, unlocked after normal completion
///     1. Open Settings → verify no lock hint
///     2. Start Quick Practice (default settings: showPreSessionWordList=true, useAnkiMode=false)
///     3. Pre-session word list appears → tap "Start Session"
///     4. Inside session: tap gear icon → Settings shows "Session settings locked" hint  [BUG 1]
///     5. Navigate back and complete all exercises correctly ("Show translation" → "Know")
///     6. "Back to menu" → verify Settings shows NO lock hint
///
///   Part B — Settings unlock after abandoning from pre-session word list  [BUG 2]
///     1. Seed 3 new words + 2 practiced/due words
///     2. Start Quick Practice → pre-session word list appears
///     3. Assert new words show NEW badge; new word tap opens WordDetails bottom sheet
///     4. Assert practiced word tap opens nothing
///     5. Tap back button to abandon without starting
///     6. Open Settings → settings must NOT be locked         [BUG 2: currently locked until fixed]
///
///   Part C — Anki mode: no pre-session list, 4 grade buttons, errors in summary
///     1. Configure: useAnkiMode=true, showPreSessionWordList=false
///     2. Start Quick Practice → LearningSessionPage opens immediately (no pre-session list)
///     3. Assert "Show translation" visible; tap it → 4 grade buttons appear
///     4. Tap "Again" to create an error, then complete remaining exercises with "Good"
///     5. Summary shows "Top 5 Words to improve:" section
///
/// ## Bug fixes expected
///   Bug 1 (Part A fails before fix): QuickPracticeCoordinator never calls
///     PracticeSessionStatefulService.initializeWords → isSessionActive stays false
///     → settings appear unlocked during session.
///   Bug 2 (Part B fails before fix): QuickPracticeCoordinator never calls
///     PracticeSessionStatefulService.cleanup() after abandoning the pre-session list
///     → isSessionActive stays true → settings remain locked after going back.
///
///   Fix: Add initializeWords() before Navigator.push and cleanup() inside the
///     finally block of QuickPracticeCoordinator.startAsync().
///
/// ## Test tier
///   Integration test (real Isar DB, real widget tree, real navigation).
///   Runs against the Windows desktop target:
///     flutter test integration_test/session_settings_flow_test.dart -d windows
///
/// ## DB strategy
///   Fresh Isar in a per-test temp dir; closed/deleted in tearDown.
///   New words  = DbWord with NO DbWordProgress (getNewWordsAsync filter: progressIsEmpty).
///   Due words  = DbWord WITH DbWordProgress (exerciseType=flipCardDutchEnglish,
///                nextReviewDate < now, lastPracticed != null).
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
import 'package:dutch_app/domain/types/setting_value_type.dart';
import 'package:dutch_app/pages/dependency_injections.dart' as pages_di;
import 'package:dutch_app/pages/exercises_selector/exercises_selector_page.dart';
import 'package:dutch_app/pages/home_page.dart';
import 'package:dutch_app/pages/settings/settings_page.dart';
import 'package:dutch_app/pages/word_collections/word_collections_list_page.dart';
import 'package:dutch_app/pages/word_collections/word_details/word_details_widget.dart';
import 'package:dutch_app/pages/word_editor/word_editor_page.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';
import 'package:provider/provider.dart';

// ── App builder ──────────────────────────────────────────────────────────────

/// Mirrors MyApp from main.dart with a clean, test-only DarkThemeToggledNotifier.
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

// ── DB seeding helpers ───────────────────────────────────────────────────────

/// Inserts a Dutch word with one English translation and NO progress records.
/// The word will be returned by [getNewWordsAsync] (filter: progressIsEmpty).
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

/// Inserts a Dutch word that has an OVERDUE [DbWordProgress] record.
/// The word will be returned by [getDueProgressAsync] (nextReviewDate < now,
/// lastPracticed != null) and will appear as "practiced" in the pre-session list.
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

    // Due progress record: nextReviewDate in the past, lastPracticed set.
    final progress = DbWordProgress()
      ..exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish
      ..nextReviewDate = DateTime.now().subtract(const Duration(hours: 2))
      ..lastPracticed = DateTime.now().subtract(const Duration(days: 1));
    await isar.dbWordProgress.put(progress);

    progress.word.value = dbWord;
    await progress.word.save();
  });
}

/// Writes a boolean setting into the DB so that [SettingsService.getSettingsAsync]
/// returns it instead of the coded default.
Future<void> _setBoolSetting(String key, bool value) async {
  final isar = DbContext.isar;
  await isar.writeTxn(() async {
    final setting = DbSettings()
      ..key = key
      ..value = value.toString()
      ..valueType = SettingValueType.bool;
    await isar.dbSettings.put(setting);
  });
}

/// Writes an integer setting into the DB.
/// [SettingsService._getInt] reads only the string value, so valueType does
/// not matter for correctness — we use [SettingValueType.string].
Future<void> _setIntSetting(String key, int value) async {
  final isar = DbContext.isar;
  await isar.writeTxn(() async {
    final setting = DbSettings()
      ..key = key
      ..value = value.toString()
      ..valueType = SettingValueType.string;
    await isar.dbSettings.put(setting);
  });
}

// ── Tests ────────────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('it_session_settings_');
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
      name: 'session_settings_isar',
    );
    await DbDefaultCollectionSeed.seedAsync();
  });

  tearDown(() async {
    await DbContext.isar.close(deleteFromDisk: true);
    await tempDir.delete(recursive: true);
  });

  // ──────────────────────────────────────────────────────────────────────────
  // Part A: Settings locked during session; unlocked after normal completion
  // ──────────────────────────────────────────────────────────────────────────
  testWidgets(
    'Part A — Settings locked during active session and unlocked after normal completion',
    (WidgetTester tester) async {
      // 5 brand-new words → fills newWordsPerSession=5 default quota.
      for (var i = 0; i < 5; i++) {
        await _seedNewWord('woord$i', 'word$i');
      }

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // ── Step 1: Open settings – must NOT be locked before any session ──────
      await tester.tap(find.byIcon(Icons.settings).first);
      await tester.pumpAndSettle();

      expect(
        find.text('Session settings locked during active session'),
        findsNothing,
        reason: 'No session active yet – settings should be unlocked',
      );

      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // ── Step 2: Start Quick Practice ──────────────────────────────────────
      await tester.tap(find.text('Quick Practice'));
      await tester.pumpAndSettle();

      // Default showPreSessionWordList=true → pre-session list appears.
      expect(find.text("Today's Words"), findsOneWidget);

      // ── Step 3: Start the session ─────────────────────────────────────────
      await tester.tap(find.text('Start Session'));
      await tester.pumpAndSettle();

      expect(find.text('Learning Session'), findsOneWidget);

      // ── Step 4: Gear icon → check settings ARE locked during session ──────
      //   [BUG 1]: This assertion FAILS until QuickPracticeCoordinator calls
      //   PracticeSessionStatefulService.initializeWords() before navigating.
      await tester.tap(find.byIcon(Icons.settings).first);
      await tester.pumpAndSettle();

      expect(
        find.text('Session settings locked during active session'),
        findsOneWidget,
        reason: 'Settings must be locked while a session is active',
      );

      // Navigate back to the session.
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();

      // ── Step 5: Complete all 5 exercises correctly ─────────────────────────
      // Default useAnkiMode=false → FlipCardExerciseWidget: "Show translation"
      // → "Know" / "Don't know" buttons.
      for (var i = 0; i < 5; i++) {
        expect(find.text('Show translation'), findsOneWidget);
        await tester.tap(find.text('Show translation'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Know'));
        await tester.pumpAndSettle();
      }

      // Session finished.
      expect(find.text('Session complete'), findsOneWidget);

      // ── Step 6: "Back to menu" → cleanup() fires → isSessionActive = false ─
      await tester.tap(find.text('Back to menu'));
      await tester.pumpAndSettle();

      expect(find.text('Home page'), findsOneWidget);

      // ── Step 7: Open settings – must NOT be locked after session ends ─────
      await tester.tap(find.byIcon(Icons.settings).first);
      await tester.pumpAndSettle();

      expect(
        find.text('Session settings locked during active session'),
        findsNothing,
        reason: 'Settings must be unlocked after the session is complete',
      );
    },
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Part B: Pre-session word list shows new/practiced words;
  //         settings must be unlocked after going back without starting
  // ──────────────────────────────────────────────────────────────────────────
  testWidgets(
    'Part B — Pre-session list shows new vs practiced; settings unlocked after abandoning',
    (WidgetTester tester) async {
      // 3 new (no progress) + 2 practiced/due (with overdue DbWordProgress).
      await _seedNewWord('nieuw0', 'new0');
      await _seedNewWord('nieuw1', 'new1');
      await _seedNewWord('nieuw2', 'new2');
      await _seedPracticedWord('oud0', 'old0');
      await _seedPracticedWord('oud1', 'old1');

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // ── Step 1: Start Quick Practice ──────────────────────────────────────
      await tester.tap(find.text('Quick Practice'));
      await tester.pumpAndSettle();

      expect(find.text("Today's Words"), findsOneWidget);

      // ── Step 2: Verify word list content ──────────────────────────────────
      // New words receive the NEW badge; practiced words do not.
      expect(
        find.text('NEW'),
        findsNWidgets(3),
        reason: '3 new words were seeded; each should display a NEW badge',
      );

      // Dutch word text for both types should be visible in the list.
      expect(find.text('nieuw0'), findsOneWidget);
      expect(find.text('oud0'), findsOneWidget);

      // ── Step 3: Tap a NEW word → WordDetails bottom sheet opens ───────────
      await tester.tap(find.text('nieuw0'));
      await tester.pumpAndSettle();

      expect(
        find.byType(WordDetails),
        findsOneWidget,
        reason: 'Tapping a new word should open the WordDetails bottom sheet',
      );

      // Dismiss: tap in the barrier area above the bottom sheet
      // (FractionallySizedBox heightFactor:0.8 → sheet occupies bottom 80%;
      //  Offset(20, 20) is well above the sheet on any desktop window).
      await tester.tapAt(const Offset(20, 20));
      await tester.pumpAndSettle();

      expect(find.byType(WordDetails), findsNothing);

      // ── Step 4: Tap a PRACTICED word → nothing should happen ──────────────
      // onTap is null for practiced words so no bottom sheet opens.
      await tester.tap(find.text('oud0'));
      await tester.pumpAndSettle();

      expect(
        find.byType(WordDetails),
        findsNothing,
        reason: 'Tapping a practiced word must not open any dialog',
      );

      // ── Step 5: Go BACK without starting the session ──────────────────────
      await tester.tap(find.byType(BackButton).first);
      await tester.pumpAndSettle();

      expect(find.text('Home page'), findsOneWidget);

      // ── Step 6: Open settings → must NOT be locked ────────────────────────
      //   [BUG 2]: This assertion FAILS until QuickPracticeCoordinator calls
      //   PracticeSessionStatefulService.cleanup() in its finally block.
      await tester.tap(find.byIcon(Icons.settings).first);
      await tester.pumpAndSettle();

      expect(
        find.text('Session settings locked during active session'),
        findsNothing,
        reason:
            'Settings must be unlocked after abandoning the pre-session word list',
      );
    },
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Part D: newWordsPerSession / repetitionsPerSession reflected in pre-session list
  // ──────────────────────────────────────────────────────────────────────────
  testWidgets(
    'Part D — newWordsPerSession and repetitionsPerSession limits are reflected in pre-session word list',
    (WidgetTester tester) async {
      // Seed MORE words than the quota allows so we can confirm the limit is
      // respected: 5 new words seeded but only 3 should appear; 4 due words
      // seeded but only 2 should appear.
      for (var i = 0; i < 5; i++) {
        await _seedNewWord('limiet_nieuw$i', 'limit_new$i');
      }
      for (var i = 0; i < 4; i++) {
        await _seedPracticedWord('limiet_oud$i', 'limit_old$i');
      }

      // Configure quota: 3 new + 2 review = 5 total expected on the list.
      await _setIntSetting('newWordsPerSession', 3);
      await _setIntSetting('repetitionsPerSession', 2);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // Start Quick Practice → default showPreSessionWordList=true.
      await tester.tap(find.text('Quick Practice'));
      await tester.pumpAndSettle();

      expect(find.text("Today's Words"), findsOneWidget);

      // Header chips must reflect the configured limits, not the total seeded.
      expect(
        find.text('5 words'),
        findsOneWidget,
        reason: '3 new + 2 review = 5 words total on the list',
      );
      expect(
        find.text('3 new'),
        findsOneWidget,
        reason:
            'newWordsPerSession=3 limits new words to 3 even though 5 were seeded',
      );
      expect(
        find.text('2 review'),
        findsOneWidget,
        reason:
            'repetitionsPerSession=2 limits review words to 2 even though 4 were seeded',
      );

      // Exactly 3 NEW badges should be visible.
      expect(
        find.text('NEW'),
        findsNWidgets(3),
        reason: 'Only 3 new-word tiles should carry a NEW badge',
      );
    },
  );

  // ──────────────────────────────────────────────────────────────────────────
  // Part C: Anki mode – no pre-session list, 4 grade buttons, errors in summary
  // ──────────────────────────────────────────────────────────────────────────
  testWidgets(
    'Part C — Anki mode: session starts directly, 4 grade buttons visible, errors appear in summary',
    (WidgetTester tester) async {
      // 5 new words for the session.
      for (var i = 0; i < 5; i++) {
        await _seedNewWord('anki$i', 'ankien$i');
      }

      // Enable anki grading and skip pre-session list.
      await _setBoolSetting('useAnkiMode', true);
      await _setBoolSetting('showPreSessionWordList', false);

      await tester.pumpWidget(_buildApp());
      await tester.pumpAndSettle();

      // ── Step 1: Quick Practice → no pre-session list ──────────────────────
      await tester.tap(find.text('Quick Practice'));
      await tester.pumpAndSettle();

      // Session starts immediately (no "Today's Words" page).
      expect(find.text("Today's Words"), findsNothing);
      expect(find.text('Learning Session'), findsOneWidget);

      // ── Step 2: Verify anki flip-card UI ──────────────────────────────────
      // First look: only "Show translation" button is visible.
      expect(find.text('Show translation'), findsOneWidget);

      await tester.tap(find.text('Show translation'));
      await tester.pumpAndSettle();

      // After tapping, all four Anki grade buttons must appear.
      expect(find.text('Again'), findsOneWidget);
      expect(find.text('Hard'), findsOneWidget);
      expect(find.text('Good'), findsOneWidget);
      expect(find.text('Easy'), findsOneWidget);

      // ── Step 3: Register an error on the first exercise ───────────────────
      // Grading "Again" increments totalWrongAnswers for that exercise and
      // re-queues it (totalCorrectAnswers=0 < numOfRequiredWords=1).
      await tester.tap(find.text('Again'));
      await tester.pumpAndSettle();

      // ── Step 4: Complete remaining exercises (including the re-queued one) ─
      // Loop until "Show translation" is no longer visible (session done).
      while (find.text('Show translation').evaluate().isNotEmpty) {
        await tester.tap(find.text('Show translation'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Good'));
        await tester.pumpAndSettle();
      }

      // ── Step 5: Verify summary shows errors ───────────────────────────────
      expect(find.text('Session complete'), findsOneWidget);

      expect(
        find.text('Top 5 Words to improve:'),
        findsOneWidget,
        reason:
            'At least one "Again" answer was given; the improvement section must appear',
      );

      // ── Step 6: Return to home ─────────────────────────────────────────────
      await tester.tap(find.text('Back to menu'));
      await tester.pumpAndSettle();

      expect(find.text('Home page'), findsOneWidget);
    },
  );
}
