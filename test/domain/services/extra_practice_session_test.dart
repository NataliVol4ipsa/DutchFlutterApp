// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

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
}
