library;

import 'dart:io';

import 'package:dutch_app/core/io/v1/mapping/words_io_mapper.dart';
import 'package:dutch_app/core/io/v1/models/export_package_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_collection_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_noun_details_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_v1.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/entities/db_settings.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_noun_details_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_verb_details_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_import_repository.dart';
import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:isar/isar.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

ExportWordV1 _word(
  String dutch,
  List<String> english, {
  PartOfSpeech pos = PartOfSpeech.unspecified,
  String? contextExample,
  String? note,
  ExportWordNounDetailsV1? nounDetails,
}) {
  return ExportWordV1(
    dutch,
    english,
    pos,
    contextExample: contextExample,
    userNote: note,
    nounDetails: nounDetails,
  );
}

ExportWordNounDetailsV1 _noun(
  DeHetType deHet, {
  String? plural,
  String? diminutive,
}) {
  return ExportWordNounDetailsV1(
    deHetType: deHet,
    pluralForm: plural,
    diminutive: diminutive,
  );
}

ExportPackageV1 _package(List<ExportWordCollectionV1> cols) =>
    ExportPackageV1(cols);

ExportWordCollectionV1 _col(String name, List<ExportWordV1> words) =>
    ExportWordCollectionV1(words, name);

// ── Fixtures ──────────────────────────────────────────────────────────────────

/// 200 words spread across 4 equal-sized collections of 50 words each.
ExportPackageV1 _largeDataset() {
  const colCount = 4;
  const wordsPerCol = 50;

  return _package([
    for (var c = 0; c < colCount; c++)
      _col('Collection $c', [
        for (var w = 0; w < wordsPerCol; w++)
          _word('woord_${c}_$w', ['word_${c}_$w', 'term_${c}_$w']),
      ]),
  ]);
}

// ── Shared setup helpers ─────────────────────────────────────────────────────

Future<(_TestServices, Directory)> _openDb(String dbName) async {
  final tempDir = await Directory.systemTemp.createTemp('it_import_export_');
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
    name: dbName,
  );
  await DbDefaultCollectionSeed.seedAsync();
  return (_TestServices(), tempDir);
}

class _TestServices {
  final dutchRepo = DutchWordsRepository();
  final englishRepo = EnglishWordsRepository();
  final nounRepo = WordNounDetailsRepository(DutchWordsRepository());
  final verbRepo = WordVerbDetailsRepository(DutchWordsRepository());

  late final importRepo = WordsImportRepository(
    englishRepo,
    dutchRepo,
    nounRepo,
    verbRepo,
  );

  final collectionsRepo = WordCollectionsRepository();

  Future<void> importPackage(ExportPackageV1 pkg) =>
      importRepo.importAsync(WordsIoMapper.toNewCollectionList(pkg));
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _TestServices svc;
  late Directory tempDir;

  setUp(() async {
    // Give each test its own uniquely-named Isar instance.
    (svc, tempDir) = await _openDb(
      'import_export_${DateTime.now().microsecondsSinceEpoch}',
    );
  });

  tearDown(() async {
    await DbContext.isar.close(deleteFromDisk: true);
    await tempDir.delete(recursive: true);
  });

  // ── 1. Basic single-collection round-trip ──────────────────────────────────

  test(
    'single collection: import then re-export preserves all words',
    () async {
      final pkg = _package([
        _col('Animals', [
          _word('hond', ['dog']),
          _word('kat', ['cat']),
          _word('vogel', ['bird']),
        ]),
      ]);

      await svc.importPackage(pkg);

      // Skip the default "General" collection (index 0) and take custom ones.
      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final custom = allCols.where((c) => c.name == 'Animals').toList();

      expect(custom, hasLength(1));
      expect(custom.first.words, hasLength(3));

      // Round-trip through the export model.
      final exported = WordsIoMapper.toExportPackageV1(custom);
      final exportedWords = exported.collections.first.words;
      final dutchWords = exportedWords.map((w) => w.dutchWord).toSet();

      expect(dutchWords, containsAll(['hond', 'kat', 'vogel']));
    },
  );

  // ── 2. Multiple collections ───────────────────────────────────────────────

  test(
    'multiple collections: each collection imported independently',
    () async {
      final pkg = _package([
        _col('Food', [
          _word('brood', ['bread']),
          _word('kaas', ['cheese']),
        ]),
        _col('Colors', [
          _word('rood', ['red']),
          _word('blauw', ['blue']),
          _word('groen', ['green']),
        ]),
        _col('Numbers', [
          _word('een', ['one']),
          _word('twee', ['two']),
          _word('drie', ['three']),
          _word('vier', ['four']),
        ]),
      ]);

      await svc.importPackage(pkg);

      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final byName = {for (final c in allCols) c.name: c};

      expect(byName['Food']?.words, hasLength(2));
      expect(byName['Colors']?.words, hasLength(3));
      expect(byName['Numbers']?.words, hasLength(4));

      // Verify collection names are preserved.
      expect(byName.keys, containsAll(['Food', 'Colors', 'Numbers']));

      // Verify content of one collection in detail.
      final foodWords = byName['Food']!.words!.map((w) => w.dutchWord).toSet();
      expect(foodWords, equals({'brood', 'kaas'}));
    },
  );

  // ── 3. Duplicate Dutch words shared across collections ────────────────────

  test(
    'duplicate Dutch words: single DbDutchWord record per unique word',
    () async {
      // 'huis' appears in both collections.
      final pkg = _package([
        _col('Home', [
          _word('huis', ['house']),
          _word('deur', ['door']),
        ]),
        _col('Family', [
          _word('huis', ['home']), // same Dutch word, different English
          _word('vader', ['father']),
        ]),
      ]);

      await svc.importPackage(pkg);

      // At DB level there must be exactly one DbDutchWord for 'huis'.
      final allDutch = await DbContext.isar.dbDutchWords.where().findAll();
      final huisEntries = allDutch.where((d) => d.word == 'huis').toList();
      expect(
        huisEntries,
        hasLength(1),
        reason: 'DbDutchWord deduplication failed for "huis"',
      );

      // Both collections still hold their own DbWord records.
      final homeCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final home = homeCols.firstWhere((c) => c.name == 'Home');
      final family = homeCols.firstWhere((c) => c.name == 'Family');

      expect(home.words, hasLength(2));
      expect(family.words, hasLength(2));
    },
  );

  // ── 4. Duplicate English words shared across collections ─────────────────

  test(
    'duplicate English words: single DbEnglishWord record per unique word',
    () async {
      // 'big' appears as an English translation in three different words.
      final pkg = _package([
        _col('Adjectives', [
          _word('groot', ['big', 'large']),
          _word('reusachtig', ['big', 'enormous', 'huge']),
        ]),
        _col('Other', [
          _word('dikke', ['big', 'thick']),
        ]),
      ]);

      await svc.importPackage(pkg);

      final allEnglish = await DbContext.isar.dbEnglishWords.where().findAll();
      final bigEntries = allEnglish.where((e) => e.word == 'big').toList();
      expect(
        bigEntries,
        hasLength(1),
        reason: 'DbEnglishWord deduplication failed for "big"',
      );
    },
  );

  // ── 5. Large dataset (regression: Isar buffer overflow) ──────────────────

  test(
    'large dataset (200 words / 4 collections) imports without error',
    () async {
      final pkg = _largeDataset();

      // Must not throw.
      await svc.importPackage(pkg);

      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final customCols = allCols
          .where((c) => c.name.startsWith('Collection '))
          .toList();

      expect(customCols, hasLength(4));

      // Verify total word count: 4 collections × 50 words = 200.
      final totalWords = customCols.fold(
        0,
        (sum, c) => sum + (c.words?.length ?? 0),
      );
      expect(totalWords, equals(200));

      // Spot-check one word from the last collection.
      final lastCol = customCols.firstWhere((c) => c.name == 'Collection 3');
      final lastColDutchWords = lastCol.words!.map((w) => w.dutchWord).toSet();
      expect(lastColDutchWords, contains('woord_3_0'));
      expect(lastColDutchWords, contains('woord_3_49'));
    },
  );

  // ── 6. Noun details survive the round-trip ────────────────────────────────

  test(
    'noun details (de/het, plural, diminutive) survive import → export',
    () async {
      final pkg = _package([
        _col('Nouns', [
          _word(
            'tafel',
            ['table'],
            pos: PartOfSpeech.noun,
            nounDetails: _noun(
              DeHetType.de,
              plural: 'tafels',
              diminutive: 'tafeltje',
            ),
          ),
          _word(
            'huis',
            ['house'],
            pos: PartOfSpeech.noun,
            nounDetails: _noun(
              DeHetType.het,
              plural: 'huizen',
              diminutive: 'huisje',
            ),
          ),
        ]),
      ]);

      await svc.importPackage(pkg);

      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final nouns = allCols.firstWhere((c) => c.name == 'Nouns');

      final tafel = nouns.words!.firstWhere((w) => w.dutchWord == 'tafel');
      expect(tafel.nounDetails?.deHetType, equals(DeHetType.de));
      expect(tafel.nounDetails?.pluralForm, equals('tafels'));
      expect(tafel.nounDetails?.diminutive, equals('tafeltje'));

      final huis = nouns.words!.firstWhere((w) => w.dutchWord == 'huis');
      expect(huis.nounDetails?.deHetType, equals(DeHetType.het));
      expect(huis.nounDetails?.pluralForm, equals('huizen'));
      expect(huis.nounDetails?.diminutive, equals('huisje'));
    },
  );

  // ── 7. Context example and user note survive the round-trip ──────────────

  test('contextExample and userNote survive import → export', () async {
    final pkg = _package([
      _col('Annotated', [
        _word(
          'lopen',
          ['to walk', 'to run'],
          contextExample: 'Ik loop naar school.',
          note: 'Irregular verb',
        ),
      ]),
    ]);

    await svc.importPackage(pkg);

    final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
    final col = allCols.firstWhere((c) => c.name == 'Annotated');
    final word = col.words!.first;

    expect(word.contextExample, equals('Ik loop naar school.'));
    expect(word.userNote, equals('Irregular verb'));
  });

  // ── 8. Re-import idempotence ──────────────────────────────────────────────

  test(
    're-importing the same package does not duplicate words in collections',
    () async {
      final pkg = _package([
        _col('Basics', [
          _word('ja', ['yes']),
          _word('nee', ['no']),
        ]),
      ]);

      await svc.importPackage(pkg);
      await svc.importPackage(pkg); // import a second time

      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final basics = allCols.where((c) => c.name == 'Basics').toList();

      // Two separate collection records are created (import always creates a new one),
      // but each should have exactly the expected word count — not doubled.
      for (final col in basics) {
        expect(
          col.words,
          hasLength(2),
          reason:
              'Collection "${col.name}" should have 2 words, not duplicated ones',
        );
      }

      // At the Dutch-word level there should still be only one DbDutchWord per word.
      final allDutch = await DbContext.isar.dbDutchWords.where().findAll();
      final jaEntries = allDutch.where((d) => d.word == 'ja').toList();
      expect(jaEntries, hasLength(1));
    },
  );

  // ── 9. Full round-trip: import → export → re-import → verify ─────────────

  test(
    'full round-trip: import → export package → re-import → words match',
    () async {
      final original = _package([
        _col('Transport', [
          _word('auto', ['car']),
          _word('fiets', ['bike', 'bicycle']),
          _word('trein', ['train']),
        ]),
      ]);

      await svc.importPackage(original);

      // Export to ExportPackageV1.
      final allCols = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final transportCol = allCols.where((c) => c.name == 'Transport').toList();
      final exported = WordsIoMapper.toExportPackageV1(transportCol);

      // Verify exported structure.
      expect(exported.collections, hasLength(1));
      expect(exported.collections.first.words, hasLength(3));
      final exportedDutch = exported.collections.first.words
          .map((w) => w.dutchWord)
          .toSet();
      expect(exportedDutch, equals({'auto', 'fiets', 'trein'}));

      // Re-import the exported data.
      await svc.importPackage(exported);

      // The re-imported collection should also have 3 words.
      final allCols2 = await svc.collectionsRepo.getCollectionsWithWordsAsync();
      final transports = allCols2.where((c) => c.name == 'Transport').toList();
      for (final col in transports) {
        expect(col.words, hasLength(3));
      }
    },
  );
}
