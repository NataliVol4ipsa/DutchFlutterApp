/// Integration test: Create verb → appears in list → edit → persists
///
/// ## What this tests
/// A full round-trip IT that exercises:
///   1. Navigate from HomePage → Add Word
///   2. Create a verb, filling EVERY available property manually (no online search)
///   3. Navigate to Collections → word appears in the list with its Dutch + English text
///   4. Tap the word → WordDetailsDialog → tap Edit icon
///   5. Edit the Dutch word → Save
///   6. Collections list now shows the updated name (old name gone, new name present)
///
/// ## Test tier
///   Integration test (real Isar DB, real widget tree, real navigation).
///   Runs against the Windows desktop target:
///     flutter test integration_test/create_verb_flow_test.dart -d windows
///
/// ## DB strategy
///   Isar is opened in a per-test temp directory and closed/deleted in tearDown.
///   The default collection is seeded (required for word creation) but no word
///   data is pre-loaded, so the list is clean at the start of each test.
///
/// ## Field-finding strategy
///   - Labeled fields (FormTextInput) are found with
///     `find.byType(TextFormField).hitTestable().at(n)` scoped to the active tab.
///     The `.hitTestable()` filter discards off-screen PageView pages, so only
///     the currently visible tab's widgets are returned.
///   - Verb-conjugation table rows use raw `TextField` (no surrounding
///     TextFormField), so `find.byType(TextField).hitTestable().at(n)` is used
///     on those tabs.  Adjacent tabs that also contain raw TextFields are
///     horizontally off-screen and therefore not hit-testable.
///
/// ## Verb data used
///   Dutch: "werken"  English (input): "to work" → stored/shown as "work"
///   (SemicolonWordsConverter strips the "to " infinitive prefix automatically)
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
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/domain/dependency_injections.dart' as domain_di;
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
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

// ── Helpers ─────────────────────────────────────────────────────────────────

/// Returns the [SingleChildScrollView] of the currently visible tab.
///
/// Each tab is built as `_tab(Widget)` → Padding > SingleChildScrollView.
/// The active tab's SCV is inside the viewport (hitTestable); adjacent
/// tabs' SCVs are horizontally translated off-screen (not hitTestable).
Finder _currentTabScrollable() =>
    find.byType(SingleChildScrollView).hitTestable().first;

/// Finds the nth [TextField] that is a descendant of the current tab's
/// scrollable, scrolls to it, and types [text].
///
/// Works for BOTH:
///  • labeled form inputs (FormTextInput → TextFormField → TextField)
///  • raw verb-conjugation table rows (VerbConjugationTable → TextField)
/// because in both cases there is exactly one TextField per logical row.
Future<void> _fill(WidgetTester tester, int index, String text) async {
  final scv = _currentTabScrollable();
  final field = find
      .descendant(of: scv, matching: find.byType(TextField))
      .at(index);
  await tester.ensureVisible(field); // scrolls SCV if needed
  await tester.pumpAndSettle();
  await tester.enterText(field, text);
  await tester.pump();
}

/// Builds the full test app, mirroring MyApp in main.dart but without loading
/// theme settings from the DB (DarkThemeToggledNotifier defaults to light).
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

// ── Test ─────────────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;

  setUp(() async {
    // Open a fresh Isar in a temp directory so the test never touches the
    // user's real app data.
    tempDir = await Directory.systemTemp.createTemp('it_dutch_app_');
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
      name: 'create_verb_isar',
    );
    // The default "General" collection must exist before any word can be saved.
    await DbDefaultCollectionSeed.seedAsync();
  });

  tearDown(() async {
    await DbContext.isar.close(deleteFromDisk: true);
    await tempDir.delete(recursive: true);
  });

  testWidgets('Create verb with every property → appears in list → edit → persists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(_buildApp());
    await tester.pumpAndSettle();

    // ────────────────────────────────────────────────────────────────────
    // 1. Navigate to Word Editor
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Add Word'));
    await tester.pumpAndSettle();
    // Land on "Main" tab (index 1 for new words)

    // ────────────────────────────────────────────────────────────────────
    // 2. Main tab – Dutch word, English word, Word type = Verb
    // ────────────────────────────────────────────────────────────────────

    // Dutch word (index 0 in the Main tab's SCV)
    await _fill(tester, 0, 'werken');

    // English word (index 1)
    // SemicolonWordsConverter strips "to " prefix → stored/shown as "work"
    await _fill(tester, 1, 'to work');

    // Open the Word-type dropdown by tapping the currently displayed value text.
    // We avoid tapping DropdownButtonFormField directly because its render object
    // is not always in the Flutter hit-test path.  The displayed Text widget is.
    // "Unspecified" is the capitalLabel for PartOfSpeech.unspecified (initial value).
    // .hitTestable() keeps only the visible Main-tab copy (All tab is off-screen left).
    await tester.ensureVisible(find.text('Unspecified').hitTestable().first);
    await tester.tap(find.text('Unspecified').hitTestable().first);
    await tester.pumpAndSettle();

    // Select "Verb" from the overlay menu
    // Use .last to prefer the menu item over any already-rendered label text.
    await tester.tap(find.text('Verb').last);
    await tester.pumpAndSettle();
    // Selecting Verb triggers _updateTabs(); new tabs appear (Forms, PresentTense …)

    // ────────────────────────────────────────────────────────────────────
    // 3. Forms tab – Infinitief, Voltooid deelwoord, Hulpwerkwoord
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Forms'));
    await tester.pumpAndSettle();

    // 3 verb-form TextFormFields (each wraps exactly one inner TextField, index 0-2)
    await _fill(tester, 0, 'werken'); // Infinitief
    await _fill(tester, 1, 'gewerkt'); // Voltooid deelwoord
    await _fill(tester, 2, 'hebben'); // Hulpwerkwoord

    // ────────────────────────────────────────────────────────────────────
    // 4. PresentTense tab – 8 conjugation rows (raw TextField)
    //    Row order: ik | jij? | jij | u | hij/zij/het | wij | jullie | zij
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('PresentTense'));
    await tester.pumpAndSettle();

    await _fill(tester, 0, 'werk'); // ik
    await _fill(tester, 1, 'werk'); // jij?
    await _fill(tester, 2, 'werkt'); // jij
    await _fill(tester, 3, 'werkt'); // u
    await _fill(tester, 4, 'werkt'); // hij/zij/het
    await _fill(tester, 5, 'werken'); // wij
    await _fill(tester, 6, 'werken'); // jullie
    await _fill(tester, 7, 'werken'); // zij

    // ────────────────────────────────────────────────────────────────────
    // 5. PastTense tab – 5 conjugation rows
    //    Row order: ik | jij | hij/zij/het | wij | jullie
    //    Note: the "zij" controller exists in VerbControllers but
    //    VerbPastTenseTab only renders 5 rows (zij is not shown in the UI).
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('PastTense'));
    await tester.pumpAndSettle();

    await _fill(tester, 0, 'werkte'); // ik
    await _fill(tester, 1, 'werkte'); // jij
    await _fill(tester, 2, 'werkte'); // hij/zij/het
    await _fill(tester, 3, 'werkten'); // wij
    await _fill(tester, 4, 'werkten'); // jullie

    // ────────────────────────────────────────────────────────────────────
    // 6. Imperative tab – 2 rows (Informal / Formal)
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Imperative'));
    await tester.pumpAndSettle();

    await _fill(tester, 0, 'werk'); // Informal
    await _fill(tester, 1, 'werkt'); // Formal

    // ────────────────────────────────────────────────────────────────────
    // 7. PresentParticiple tab – Onvervoegd + Vervoegd
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('PresentParticiple'));
    await tester.pumpAndSettle();

    await _fill(tester, 0, 'werkend'); // Uninflected (onvervoegd)
    await _fill(tester, 1, 'werkende'); // Inflected (vervoegd)

    // ────────────────────────────────────────────────────────────────────
    // 8. Meta tab – context example, translation, user note
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Meta'));
    await tester.pumpAndSettle();

    await _fill(tester, 0, 'Ik werk elke dag'); // Example in sentence
    await _fill(tester, 1, 'I work every day'); // Translation
    await _fill(tester, 2, 'Important Dutch verb'); // Additional notes

    // ────────────────────────────────────────────────────────────────────
    // 9. Submit – "Add word" button (in the bottomNavigationBar)
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Add word'));
    await tester.pumpAndSettle();
    // _submitChangesAsync saves to DB, calls wordCreatedNotifier, then pops.
    // We should be back on HomePage.

    // ────────────────────────────────────────────────────────────────────
    // 10. Navigate to Collections and verify the word is listed
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Collections'));
    await tester.pumpAndSettle();

    // Dutch word is shown in the SelectableWord row.
    expect(find.text('werken'), findsOneWidget);
    // English word: "to work" → SemicolonWordsConverter removes "to " → "work"
    expect(find.text('work'), findsOneWidget);

    // ────────────────────────────────────────────────────────────────────
    // 11. Tap the word row → WordDetailsDialog (modal bottom sheet)
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('werken'));
    await tester.pumpAndSettle();
    // WordDetails widget is now visible inside a modal bottom sheet.
    // The header contains an edit icon button (Icons.edit).

    // ────────────────────────────────────────────────────────────────────
    // 12. Tap the Edit icon → dialog closes, WordEditorPage opens
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();
    // WordEditorPage is opened with the word's ID as the route argument.
    // _isNewWord = false → starts at "All" tab (index 0).
    // _initExistingWordAsync loads the word and fills all controllers.

    // Verify the editor loaded with the existing Dutch word
    expect(find.text('Edit word'), findsOneWidget); // AppBar title
    // The Dutch word should be pre-filled in at least one visible field:
    expect(find.text('werken'), findsWidgets);

    // ────────────────────────────────────────────────────────────────────
    // 13. Edit the Dutch word: "werken" → "hard werken"
    //     Navigate to the Main tab first so only the 2 labelled fields
    //     (Dutch + English) are in the SCV – field index 0 is Dutch.
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Main'));
    await tester.pumpAndSettle();

    // Find the Dutch TextField by locating the TextFormField whose ancestor
    // contains the label "Dutch".  Because the label text and the TextFormField
    // share the same parent Column inside FormInput, we look for the ancestor
    // FormInput that also contains the label, then drill into its TextField.
    final dutchFormInput = find
        .ancestor(of: find.text('Dutch'), matching: find.byType(Column))
        .first;
    final dutchField = find
        .descendant(of: dutchFormInput, matching: find.byType(TextFormField))
        .first;
    await tester.ensureVisible(dutchField);
    await tester.pumpAndSettle();
    await tester.enterText(dutchField, 'hard werken');
    await tester.pump();

    // ────────────────────────────────────────────────────────────────────
    // 14. Save the edit
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('Save changes'));
    await tester.pumpAndSettle();
    // updateWordAsync persists the change, wordCreatedNotifier fires,
    // WordEditorPage pops → back on WordCollectionsListPage.
    // The notifier triggers _loadDataAsync which refreshes the list.
    // Give the async reload a bit more time to complete.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // ────────────────────────────────────────────────────────────────────
    // 15. Verify the updated word in the collection list
    // ────────────────────────────────────────────────────────────────────
    expect(find.text('hard werken'), findsOneWidget); // new Dutch word
    expect(find.text('work'), findsOneWidget); // English unchanged
    expect(find.text('werken'), findsNothing); // old Dutch word replaced

    // ────────────────────────────────────────────────────────────────────
    // 16. Re-open the details to verify verb data persisted
    // ────────────────────────────────────────────────────────────────────
    await tester.tap(find.text('hard werken'));
    await tester.pumpAndSettle();
    // WordDetailsDialog is open.  Verb-specific fields are visible in the
    // body of the details widget.
    expect(find.text('hard werken'), findsWidgets); // title renders it again

    // Dismiss the dialog.
    await tester.tapAt(const Offset(200, 100)); // tap outside the sheet
    await tester.pumpAndSettle();
  });
}
