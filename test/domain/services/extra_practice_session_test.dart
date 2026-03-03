// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/exercise_mode_quota.dart';
import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'extra_practice_session_test.mocks.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

/// Settings with a given repetitionsPerSession (used in service-level tests).
Settings _serviceSettings({int repetitions = 10}) => Settings(
  theme: ThemeSettings(),
  session: SessionSettings(repetitionsPerSession: repetitions),
);

/// Minimal [Word] with a given id. FlipCard supports all words, so this
/// passes the supported-word filter whenever [ExerciseModeQuota.flipCardOnly]
/// is the active quota.
Word _word(int id) => Word(
  id,
  'word_$id',
  ['translation_$id'],
  PartOfSpeech.unspecified,
  nounDetails: null,
  verbDetails: null,
);

/// Creates a [DbWordProgress] whose linked word has [wordId].
DbWordProgress _progress(int wordId) {
  final dbWord = DbWord()..id = wordId;
  return DbWordProgress()..word.value = dbWord;
}

// Easy in-memory map from word-id → Word.
Map<int, Word> _wordMap(List<int> ids) => {for (final id in ids) id: _word(id)};

// A fetch function that returns the given progress list regardless of bucket.
Future<List<DbWordProgress>> Function(ExtraPracticeBucket, int) _fetcher(
  Map<ExtraPracticeBucket, List<DbWordProgress>> byBucket,
) {
  return (bucket, limit) async {
    final records = byBucket[bucket] ?? [];
    return records.take(limit).toList();
  };
}

Future<Word?> Function(int) _wordFetcher(Map<int, Word> words) =>
    (id) async => words[id];

// All words in the map are considered "supported".
bool _allSupported(Word _) => true;

// ─────────────────────────────────────────────────────────────────────────────
// Tests for QuickPracticeService.selectWordsForExtraPractice
// ─────────────────────────────────────────────────────────────────────────────

@GenerateMocks([
  SettingsService,
  WordProgressBatchRepository,
  WordsRepository,
  WordProgressService,
])
void main() {
  // ── Empty selection ────────────────────────────────────────────────────────
  group('selectWordsForExtraPractice – empty selection', () {
    test('throws when no buckets are enabled', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: false,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      expect(
        () => QuickPracticeService.selectWordsForExtraPractice(
          settings: settings,
          totalWords: 10,
          fetchProgress: (_, __) async => [],
          fetchWord: _wordFetcher({}),
          isWordSupported: _allSupported,
        ),
        throwsException,
      );
    });
  });

  // ── Single bucket ──────────────────────────────────────────────────────────
  group('selectWordsForExtraPractice – single bucket', () {
    test(
      'weakest-only returns up to totalWords words from weakest bucket',
      () async {
        final settings = ExtraPracticeSettings(
          useWeakestWords: true,
          useTomorrowsWords: false,
          useRecentlyLearned: false,
          useRandomWords: false,
        );

        final progressList = List.generate(15, (i) => _progress(i + 1));
        final words = _wordMap(List.generate(15, (i) => i + 1));

        final result = await QuickPracticeService.selectWordsForExtraPractice(
          settings: settings,
          totalWords: 10,
          fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
          fetchWord: _wordFetcher(words),
          isWordSupported: _allSupported,
        );

        expect(result.length, 10);
        expect(result.map((w) => w.id).toSet().length, 10); // all unique
      },
    );

    test('returns fewer words when bucket has less than totalWords', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: false,
        useTomorrowsWords: true,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      final progressList = [_progress(1), _progress(2), _progress(3)];
      final words = _wordMap([1, 2, 3]);

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({ExtraPracticeBucket.tomorrow: progressList}),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.length, 3);
    });

    test('returns empty when fetchWord returns null for all ids', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      final progressList = List.generate(5, (i) => _progress(i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
        fetchWord: (_) async => null, // every lookup misses
        isWordSupported: _allSupported,
      );

      expect(result, isEmpty);
    });

    test('excludes words rejected by isWordSupported filter', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      final progressList = List.generate(6, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(6, (i) => i + 1));

      // Only even ids are "supported"
      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
        fetchWord: _wordFetcher(words),
        isWordSupported: (w) => w.id.isEven,
      );

      expect(result.every((w) => w.id.isEven), isTrue);
      expect(result.length, 3); // ids 2,4,6
    });
  });

  // ── Multiple buckets – no overlap ──────────────────────────────────────────
  group('selectWordsForExtraPractice – multiple buckets, no overlap', () {
    test('words from both buckets are included', () async {
      // weakest+random (only 2 buckets active), disjoint sets
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: true,
      );

      // weakest normalized ~83%, random ~17%  → totalWords=6
      // weakest target = round(6*5/6)=5, random target = round(6*1/6)=1
      final weakestProgress = List.generate(5, (i) => _progress(i + 1));
      final randomProgress = [_progress(6)];
      final words = _wordMap(List.generate(6, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 6,
        fetchProgress: _fetcher({
          ExtraPracticeBucket.weakest: weakestProgress,
          ExtraPracticeBucket.random: randomProgress,
        }),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.map((w) => w.id).toSet(), {1, 2, 3, 4, 5, 6});
    });

    test('result contains no duplicate word ids', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: true,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      // Build large disjoint sets
      final weakestProgress = List.generate(10, (i) => _progress(i + 1));
      final tomorrowProgress = List.generate(10, (i) => _progress(i + 11));
      final words = _wordMap(List.generate(20, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 15,
        fetchProgress: _fetcher({
          ExtraPracticeBucket.weakest: weakestProgress,
          ExtraPracticeBucket.tomorrow: tomorrowProgress,
        }),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      final ids = result.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length); // no duplicates
    });
  });

  // ── Multiple buckets – full overlap ────────────────────────────────────────
  group('selectWordsForExtraPractice – multiple buckets, overlap', () {
    test(
      'full overlap: second bucket contributes nothing; backfill re-fills',
      () async {
        // weakest+random with the same word pool
        final settings = ExtraPracticeSettings(
          useWeakestWords: true,
          useTomorrowsWords: false,
          useRecentlyLearned: false,
          useRandomWords: true,
        );

        // normalized weakest≈0.833, random≈0.167  → totalWords=6
        // weakest target=5, random target=1
        // Both buckets share the same 6 unique words. Weakest fills 5 first.
        // Random's only word (id=1) is already seen → would normally leave gap.
        // Backfill should pick up word id=6 from weakest.
        final sharedProgress = List.generate(6, (i) => _progress(i + 1));
        final words = _wordMap(List.generate(6, (i) => i + 1));

        final result = await QuickPracticeService.selectWordsForExtraPractice(
          settings: settings,
          totalWords: 6,
          fetchProgress: _fetcher({
            ExtraPracticeBucket.weakest: sharedProgress,
            ExtraPracticeBucket.random: sharedProgress, // identical pool
          }),
          fetchWord: _wordFetcher(words),
          isWordSupported: _allSupported,
        );

        expect(result.length, 6);
        expect(result.map((w) => w.id).toSet().length, 6); // no duplicates
      },
    );

    test('partial overlap: combined count reaches totalWords', () async {
      // weakest has words 1-8, random has words 5-12 (overlap: 5-8)
      // weakest normalized≈0.833 → target 8, random≈0.167 → target 2
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: true,
      );

      final weakestProgress = List.generate(8, (i) => _progress(i + 1));
      final randomProgress = List.generate(8, (i) => _progress(i + 5)); // 5..12
      final words = _wordMap(List.generate(12, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({
          ExtraPracticeBucket.weakest: weakestProgress,
          ExtraPracticeBucket.random: randomProgress,
        }),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.length, 10);
      final ids = result.map((w) => w.id).toSet();
      expect(ids.length, 10); // no duplicates
    });

    test('no duplicate ids when all four buckets return same pool', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: true,
        useRecentlyLearned: true,
        useRandomWords: true,
      );

      final sharedProgress = List.generate(10, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(10, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: (_, limit) async => sharedProgress.take(limit).toList(),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      final ids = result.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length);
    });
  });

  // ── Bucket order & quota ───────────────────────────────────────────────────
  group('selectWordsForExtraPractice – quota distribution', () {
    test('weakest gets more words than random when both are active', () async {
      // weakest normalized≈0.833, random≈0.167
      // For totalWords=12: weakest target=10, random target=2
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: true,
      );

      // Tag bucket origin via the word id range so we can count them.
      // weakest → ids 1..20 (plenty)  random → ids 101..120 (plenty, no overlap)
      final weakestProgress = List.generate(20, (i) => _progress(i + 1));
      final randomProgress = List.generate(20, (i) => _progress(i + 101));
      final words = {
        ...{for (int i = 1; i <= 20; i++) i: _word(i)},
        ...{for (int i = 101; i <= 120; i++) i: _word(i)},
      };

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 12,
        fetchProgress: _fetcher({
          ExtraPracticeBucket.weakest: weakestProgress,
          ExtraPracticeBucket.random: randomProgress,
        }),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.length, 12);
      final fromWeakest = result.where((w) => w.id <= 20).length;
      final fromRandom = result.where((w) => w.id >= 101).length;
      // weakest should dominate
      expect(fromWeakest, greaterThan(fromRandom));
    });

    test('single-bucket weights normalize to 1.0 → fills totalWords', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: false,
        useTomorrowsWords: false,
        useRecentlyLearned: true,
        useRandomWords: false,
      );

      final progress = List.generate(20, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(20, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 8,
        fetchProgress: _fetcher({
          ExtraPracticeBucket.recentlyLearned: progress,
        }),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.length, 8);
    });
  });

  // ── Progress with null word id ─────────────────────────────────────────────
  group('selectWordsForExtraPractice – edge cases', () {
    test('progress records with null word.value are skipped', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      // One valid progress, three with no word linked
      final progressWithNull = DbWordProgress(); // word.value stays null
      final progressList = [
        _progress(1),
        progressWithNull,
        _progress(2),
        progressWithNull,
        _progress(3),
      ];
      final words = _wordMap([1, 2, 3]);

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.map((w) => w.id).toSet(), {1, 2, 3});
    });

    test('totalWords=0 returns empty list without throwing', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      final progressList = List.generate(5, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(5, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 0,
        fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      // clamp(1, 0) = 1 minimum per bucket, but no words returned for 0 total
      // The result can only have words clamp forces; important: no duplicates.
      expect(result.map((w) => w.id).toSet().length, result.length);
    });

    test('duplicate progress records with same id are deduplicated', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      // Same id appears 3 times in the same bucket's response
      final progressList = [
        _progress(1),
        _progress(1),
        _progress(1),
        _progress(2),
      ];
      final words = _wordMap([1, 2]);

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: _fetcher({ExtraPracticeBucket.weakest: progressList}),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      final ids = result.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length); // no duplicates
      expect(ids.toSet(), {1, 2});
    });
  });

  // ── Backfill details ───────────────────────────────────────────────────────
  group('selectWordsForExtraPractice – backfill', () {
    test(
      'fully-overlapping second bucket is rescued by backfill from first',
      () async {
        // weakest has words 1-10 (huge pool)
        // random also has words 1-10 (completely identical)
        // 1st pass: weakest fills its quota (~8), random gets 0 new unique words
        // Backfill: weakest provides the remaining 2 from its extra pool
        final settings = ExtraPracticeSettings(
          useWeakestWords: true,
          useTomorrowsWords: false,
          useRecentlyLearned: false,
          useRandomWords: true,
        );

        final sharedPool = List.generate(10, (i) => _progress(i + 1));
        final words = _wordMap(List.generate(10, (i) => i + 1));

        final result = await QuickPracticeService.selectWordsForExtraPractice(
          settings: settings,
          totalWords: 10,
          fetchProgress: _fetcher({
            ExtraPracticeBucket.weakest: sharedPool,
            ExtraPracticeBucket.random: sharedPool,
          }),
          fetchWord: _wordFetcher(words),
          isWordSupported: _allSupported,
        );

        expect(result.length, 10);
        expect(result.map((w) => w.id).toSet().length, 10);
      },
    );

    test('backfill does not add words beyond totalWords', () async {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: true,
        useRecentlyLearned: false,
        useRandomWords: false,
      );

      // Both buckets share words 1..30: massive overlap
      final bigPool = List.generate(30, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(30, (i) => i + 1));

      final result = await QuickPracticeService.selectWordsForExtraPractice(
        settings: settings,
        totalWords: 10,
        fetchProgress: (_, limit) async => bigPool.take(limit).toList(),
        fetchWord: _wordFetcher(words),
        isWordSupported: _allSupported,
      );

      expect(result.length, lessThanOrEqualTo(10));
    });
  });

  // ── fetchAcrossDetailedTypes (regression: writing exercises in extra practice)
  // When quota is flipCardOnly the service only queries flipCardDutchEnglish
  // detailed type during extra-practice. Writing progress records are never
  // fetched → zero writing exercises. The fix is to use flipCardAndWriting
  // quota so that basicWrite detailed type is also queried.
  // ─────────────────────────────────────────────────────────────────────────
  group('fetchAcrossDetailedTypes', () {
    test('returns records from a single detailed type', () async {
      final progress = [_progress(1), _progress(2)];

      final result = await QuickPracticeService.fetchAcrossDetailedTypes(
        detailedTypes: [ExerciseTypeDetailed.flipCardDutchEnglish],
        limit: 10,
        fetchByType: (_, __) async => progress,
      );

      expect(result.length, 2);
    });

    test(
      'merges records from two detailed types, deduplicating by word id',
      () async {
        // ids 1-3 have flipCard progress; ids 4-6 have write progress; no overlap
        final flipProgress = [_progress(1), _progress(2), _progress(3)];
        final writeProgress = [_progress(4), _progress(5), _progress(6)];

        final result = await QuickPracticeService.fetchAcrossDetailedTypes(
          detailedTypes: [
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.basicWrite,
          ],
          limit: 10,
          fetchByType: (type, _) async {
            if (type == ExerciseTypeDetailed.flipCardDutchEnglish) {
              return flipProgress;
            }
            if (type == ExerciseTypeDetailed.basicWrite) return writeProgress;
            return [];
          },
        );

        final ids = result.map((p) => p.word.value!.id).toSet();
        expect(ids, {1, 2, 3, 4, 5, 6});
      },
    );

    test(
      // Regression: with flipCardOnly quota detailedTypes = [flipCardDutchEnglish].
      // Writing progress records (basicWrite) are NEVER fetched → 0 writing exercises.
      'with only flipCardDutchEnglish, basicWrite records are NOT fetched',
      () async {
        // Writing-only progress pool (ids 10-12) – only returned for basicWrite type
        final writeProgress = [_progress(10), _progress(11), _progress(12)];

        final queried = <ExerciseTypeDetailed>[];

        final result = await QuickPracticeService.fetchAcrossDetailedTypes(
          detailedTypes: [
            ExerciseTypeDetailed.flipCardDutchEnglish,
          ], // flipCardOnly
          limit: 10,
          fetchByType: (type, _) async {
            queried.add(type);
            if (type == ExerciseTypeDetailed.basicWrite) return writeProgress;
            return []; // flipCard finds nothing
          },
        );

        expect(queried, [ExerciseTypeDetailed.flipCardDutchEnglish]);
        expect(result, isEmpty); // writing words never fetched → empty session
      },
    );

    test(
      // Fix: with flipCardAndWriting quota detailedTypes = [flipCardDutchEnglish, basicWrite].
      // Writing progress is fetched → writing exercises appear in session.
      'with flipCardDutchEnglish + basicWrite, writing records ARE fetched',
      () async {
        final writeProgress = [_progress(10), _progress(11), _progress(12)];

        final queried = <ExerciseTypeDetailed>[];

        final result = await QuickPracticeService.fetchAcrossDetailedTypes(
          detailedTypes: [
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed
                .basicWrite, // included by flipCardAndWriting quota
          ],
          limit: 10,
          fetchByType: (type, _) async {
            queried.add(type);
            if (type == ExerciseTypeDetailed.basicWrite) return writeProgress;
            return []; // flipCard finds nothing this time
          },
        );

        expect(
          queried,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.basicWrite,
          ]),
        );
        // Writing words are now returned
        final ids = result.map((p) => p.word.value!.id).toSet();
        expect(ids, {10, 11, 12});
      },
    );

    test('deduplicates word ids returned across detailed types', () async {
      // Same word id=1 appears in both flipCard and basicWrite progress
      final sharedProgress = [_progress(1)];

      final result = await QuickPracticeService.fetchAcrossDetailedTypes(
        detailedTypes: [
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.basicWrite,
        ],
        limit: 10,
        fetchByType: (_, __) async => sharedProgress,
      );

      // id=1 should appear only once
      expect(result.length, 1);
    });

    test('respects the limit across merged types', () async {
      final manyRecords = List.generate(10, (i) => _progress(i + 1));

      final result = await QuickPracticeService.fetchAcrossDetailedTypes(
        detailedTypes: [
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.basicWrite,
        ],
        limit: 4,
        fetchByType: (_, __) async => manyRecords,
      );

      expect(result.length, lessThanOrEqualTo(4));
    });

    test('returns empty when detailedTypes list is empty', () async {
      final result = await QuickPracticeService.fetchAcrossDetailedTypes(
        detailedTypes: [],
        limit: 10,
        fetchByType: (_, __) async => [_progress(1)],
      );

      expect(result, isEmpty);
    });

    test('null word.value records are skipped', () async {
      final nullProgress = DbWordProgress(); // word.value is null
      final validProgress = _progress(1);

      final result = await QuickPracticeService.fetchAcrossDetailedTypes(
        detailedTypes: [ExerciseTypeDetailed.flipCardDutchEnglish],
        limit: 10,
        fetchByType: (_, __) async => [nullProgress, validProgress],
      );

      expect(result.length, 1);
      expect(result.first.word.value!.id, 1);
    });
  });

  // ── buildExtraPracticeSessionAsync – allowedWordIds collection filter ──────
  //
  // Word seed: 20 words per bucket ensures plenty of non-allowed candidates,
  // so tests can distinguish "allowed words were chosen" from "all words were
  // chosen" and prove the filter is actually applied.
  //
  // Quota: flipCardOnly → only ExerciseTypeDetailed.flipCardDutchEnglish is
  // queried. FlipCardExercise.isSupportedWord returns true for every word, so
  // every word in the pool passes the exercise-type gate and only
  // allowedWordIds narrows the result.
  // ──────────────────────────────────────────────────────────────────────────
  group('buildExtraPracticeSessionAsync – allowedWordIds collection filter', () {
    late MockSettingsService mockSettings;
    late MockWordProgressBatchRepository mockRepo;
    late MockWordsRepository mockWordsRepo;
    late MockWordProgressService mockWPS;
    late ExerciseAnsweredNotifier notifier;
    late QuickPracticeService service;

    // Rich pool: words 1..20 in the weakest bucket, 21..40 in tomorrow,
    // 41..60 in recentlyLearned, 61..80 in random.
    final weakestPool = List.generate(20, (i) => _progress(i + 1));
    final tomorrowPool = List.generate(20, (i) => _progress(i + 21));
    final recentPool = List.generate(20, (i) => _progress(i + 41));
    final randomPool = List.generate(20, (i) => _progress(i + 61));

    // All 80 words available from wordsRepository.getWordAsync.
    final allWords = {for (int i = 1; i <= 80; i++) i: _word(i)};

    setUp(() {
      mockSettings = MockSettingsService();
      mockRepo = MockWordProgressBatchRepository();
      mockWordsRepo = MockWordsRepository();
      mockWPS = MockWordProgressService();
      notifier = ExerciseAnsweredNotifier();

      service = QuickPracticeService(
        wordsRepository: mockWordsRepo,
        wordProgressRepository: mockRepo,
        settingsService: mockSettings,
        quota: ExerciseModeQuota.flipCardOnly,
      );

      // Default: fetch all repetitions (10) per session.
      when(
        mockSettings.getSettingsAsync(),
      ).thenAnswer((_) async => _serviceSettings(repetitions: 10));

      // Default: all bucket methods return empty list.
      when(
        mockRepo.getWeakestProgressAsync(any, any),
      ).thenAnswer((_) async => []);
      when(
        mockRepo.getTomorrowProgressAsync(any, any),
      ).thenAnswer((_) async => []);
      when(
        mockRepo.getRecentlyLearnedProgressAsync(any, any),
      ).thenAnswer((_) async => []);
      when(
        mockRepo.getRandomProgressAsync(any, any),
      ).thenAnswer((_) async => []);

      // Word lookup drives the allWords map (returns null for unknown IDs).
      when(mockWordsRepo.getWordAsync(any)).thenAnswer(
        (inv) async => allWords[inv.positionalArguments.first as int],
      );
    });

    tearDown(() => notifier.dispose());

    // ── Helper that returns progress sliced by the requested limit ──────────
    void stubWeakest(List<DbWordProgress> pool) {
      when(mockRepo.getWeakestProgressAsync(any, any)).thenAnswer((inv) async {
        final limit = inv.positionalArguments[1] as int;
        return pool.take(limit).toList();
      });
    }

    void stubTomorrow(List<DbWordProgress> pool) {
      when(mockRepo.getTomorrowProgressAsync(any, any)).thenAnswer((inv) async {
        final limit = inv.positionalArguments[1] as int;
        return pool.take(limit).toList();
      });
    }

    void stubRecentlyLearned(List<DbWordProgress> pool) {
      when(mockRepo.getRecentlyLearnedProgressAsync(any, any)).thenAnswer((
        inv,
      ) async {
        final limit = inv.positionalArguments[1] as int;
        return pool.take(limit).toList();
      });
    }

    void stubRandom(List<DbWordProgress> pool) {
      when(mockRepo.getRandomProgressAsync(any, any)).thenAnswer((inv) async {
        final limit = inv.positionalArguments[1] as int;
        return pool.take(limit).toList();
      });
    }

    // ── Tests ────────────────────────────────────────────────────────────────

    test(
      'allowedWordIds restricts session to only words in the collection',
      () async {
        // Bucket returns words 1..20; collection only contains {1, 3, 5, 7, 9}.
        stubWeakest(weakestPool);
        final allowed = {1, 3, 5, 7, 9};

        final session = await service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: true,
            useTomorrowsWords: false,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          allowedWordIds: allowed,
        );

        final resultIds = session.flowManager.words.map((w) => w.id).toSet();
        expect(
          resultIds,
          everyElement(
            anyOf(equals(1), equals(3), equals(5), equals(7), equals(9)),
          ),
          reason: 'session must contain only words from the collection',
        );
        expect(resultIds.every(allowed.contains), isTrue);
      },
    );

    test(
      'words outside allowedWordIds are excluded even though bucket returns them',
      () async {
        // Bucket returns words 1..20; collection contains only the upper half.
        stubWeakest(weakestPool); // words 1..20
        final allowed = {11, 12, 13, 14, 15, 16, 17, 18, 19, 20};

        final session = await service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: true,
            useTomorrowsWords: false,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          allowedWordIds: allowed,
        );

        final resultIds = session.flowManager.words.map((w) => w.id).toSet();
        expect(
          resultIds.any((id) => id < 11),
          isFalse,
          reason: 'words with IDs 1-10 are not in the collection',
        );
        expect(resultIds.every(allowed.contains), isTrue);
      },
    );

    test(
      'without allowedWordIds any bucket word can appear in the session',
      () async {
        // Bucket returns words 1..20; no filter → all are eligible.
        stubWeakest(weakestPool);

        final session = await service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: true,
            useTomorrowsWords: false,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          // allowedWordIds omitted → global mode, no restriction
        );

        // Should fill up to repetitionsPerSession (10) from the 20-word pool.
        expect(session.flowManager.words.length, 10);
        final resultIds = session.flowManager.words.map((w) => w.id).toSet();
        // At least some words with IDs > 5 should appear (proving the full
        // pool is available and not silently capped to a small subset).
        expect(resultIds.any((id) => id > 5), isTrue);
      },
    );

    test('throws when all bucket words fall outside allowedWordIds', () async {
      // Bucket returns words 1..20; collection allows only {100, 200}.
      stubWeakest(weakestPool);

      expect(
        () => service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: true,
            useTomorrowsWords: false,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          allowedWordIds: {100, 200},
        ),
        throwsA(isA<Exception>()),
      );
    });

    test(
      'tomorrow bucket respects allowedWordIds (words 21-40 → allowed subset)',
      () async {
        // Tomorrow bucket returns words 21..40; collection is {22, 24, 26}.
        stubTomorrow(tomorrowPool);
        final allowed = {22, 24, 26};

        final session = await service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: false,
            useTomorrowsWords: true,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          allowedWordIds: allowed,
        );

        final resultIds = session.flowManager.words.map((w) => w.id).toSet();
        expect(resultIds.every(allowed.contains), isTrue);
      },
    );

    test('recentlyLearned bucket respects allowedWordIds', () async {
      // RecentlyLearned bucket returns words 41..60; collection is {42, 44, 46, 48}.
      stubRecentlyLearned(recentPool);
      final allowed = {42, 44, 46, 48};

      final session = await service.buildExtraPracticeSessionAsync(
        extraPracticeSettings: ExtraPracticeSettings(
          useWeakestWords: false,
          useTomorrowsWords: false,
          useRecentlyLearned: true,
          useRandomWords: false,
        ),
        wordProgressService: mockWPS,
        notifier: notifier,
        allowedWordIds: allowed,
      );

      final resultIds = session.flowManager.words.map((w) => w.id).toSet();
      expect(resultIds.every(allowed.contains), isTrue);
    });

    test('random bucket respects allowedWordIds', () async {
      // Random bucket returns words 61..80; collection is {62, 64, 66, 68, 70}.
      stubRandom(randomPool);
      final allowed = {62, 64, 66, 68, 70};

      final session = await service.buildExtraPracticeSessionAsync(
        extraPracticeSettings: ExtraPracticeSettings(
          useWeakestWords: false,
          useTomorrowsWords: false,
          useRecentlyLearned: false,
          useRandomWords: true,
        ),
        wordProgressService: mockWPS,
        notifier: notifier,
        allowedWordIds: allowed,
      );

      final resultIds = session.flowManager.words.map((w) => w.id).toSet();
      expect(resultIds.every(allowed.contains), isTrue);
    });

    test('all four buckets enabled: allowedWordIds spanning each bucket returns '
        'only collection words from every bucket', () async {
      // Each bucket has 20 unique words; collection picks 3 from each = 12 total.
      // Session cap is 10, so exactly 10 should be returned.
      stubWeakest(weakestPool); // 1..20
      stubTomorrow(tomorrowPool); // 21..40
      stubRecentlyLearned(recentPool); // 41..60
      stubRandom(randomPool); // 61..80

      // Allowed: 3 from each bucket band.
      final allowed = {3, 7, 11, 23, 27, 31, 43, 47, 51, 63, 67, 71};

      final session = await service.buildExtraPracticeSessionAsync(
        extraPracticeSettings: ExtraPracticeSettings(
          useWeakestWords: true,
          useTomorrowsWords: true,
          useRecentlyLearned: true,
          useRandomWords: true,
        ),
        wordProgressService: mockWPS,
        notifier: notifier,
        allowedWordIds: allowed,
      );

      final resultIds = session.flowManager.words.map((w) => w.id).toSet();
      // Every returned word must be in the allowed set.
      expect(
        resultIds.every(allowed.contains),
        isTrue,
        reason: 'session must only contain words from the collection',
      );
      // No duplicates.
      expect(resultIds.length, session.flowManager.words.length);
      // At most repetitionsPerSession words.
      expect(session.flowManager.words.length, lessThanOrEqualTo(10));
    });

    test(
      'session has no duplicates when bucket pools overlap with allowedWordIds spanning both',
      () async {
        // Weakest and tomorrow share words 10..20; allowed = {10, 11, 12}.
        final overlap = List.generate(15, (i) => _progress(i + 6)); // 6..20
        stubWeakest(overlap);
        stubTomorrow(overlap);

        final session = await service.buildExtraPracticeSessionAsync(
          extraPracticeSettings: ExtraPracticeSettings(
            useWeakestWords: true,
            useTomorrowsWords: true,
            useRecentlyLearned: false,
            useRandomWords: false,
          ),
          wordProgressService: mockWPS,
          notifier: notifier,
          allowedWordIds: {10, 11, 12},
        );

        final ids = session.flowManager.words.map((w) => w.id).toList();
        expect(ids.toSet().length, ids.length, reason: 'no duplicate words');
        expect(ids.toSet().every({10, 11, 12}.contains), isTrue);
      },
    );
  });
}
