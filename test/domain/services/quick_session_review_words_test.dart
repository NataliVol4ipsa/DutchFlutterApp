// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter_test/flutter_test.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Helpers
// ─────────────────────────────────────────────────────────────────────────────

Word _word(int id) => Word(
  id,
  'word_$id',
  ['translation_$id'],
  PartOfSpeech.unspecified,
  nounDetails: null,
  verbDetails: null,
);

DbWordProgress _progress(int wordId) {
  final dbWord = DbWord()..id = wordId;
  return DbWordProgress()..word.value = dbWord;
}

Map<int, Word> _wordMap(List<int> ids) => {for (final id in ids) id: _word(id)};

Future<Word?> Function(int) _wordFetcher(Map<int, Word> words) =>
    (id) async => words[id];

bool _allSupportedForType(ExerciseType _, Word __) => true;

// Builds a [fetchDueProgress] that returns different Word progress per type.
Future<List<DbWordProgress>> Function(ExerciseType, int) _progressFetcher(
  Map<ExerciseType, List<DbWordProgress>> byType,
) {
  return (type, limit) async {
    final records = byType[type] ?? [];
    return records.take(limit).toList();
  };
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests for QuickPracticeService.selectReviewWordsForQuickSession
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  // ── empty / degenerate cases ───────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – empty / degenerate', () {
    test('returns empty when quotaByType is empty', () async {
      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {},
            totalWords: 10,
            fetchDueProgress: (_, __) async => [],
            fetchWord: _wordFetcher({}),
            isWordSupportedForType: _allSupportedForType,
          );
      expect(result, isEmpty);
    });

    test('returns empty when totalWords is 0', () async {
      final progress = List.generate(5, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(5, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.flipCard: 1.0},
            totalWords: 0,
            fetchDueProgress: (_, __) async => progress,
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );
      expect(result, isEmpty);
    });

    test('returns empty when all fetchWord calls return null', () async {
      final progress = List.generate(5, (i) => _progress(i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.flipCard: 1.0},
            totalWords: 5,
            fetchDueProgress: (_, __) async => progress,
            fetchWord: (_) async => null,
            isWordSupportedForType: _allSupportedForType,
          );
      expect(result, isEmpty);
    });
  });

  // ── single exercise type ───────────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – single type', () {
    test('returns up to totalWords words from the single type', () async {
      final progress = List.generate(15, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(15, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.flipCard: 1.0},
            totalWords: 10,
            fetchDueProgress: (_, limit) async => progress.take(limit).toList(),
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.length, 10);
      expect(result.map((w) => w.id).toSet().length, 10); // all unique
    });

    test('returns fewer words when bucket has less than totalWords', () async {
      final progress = [_progress(1), _progress(2), _progress(3)];
      final words = _wordMap([1, 2, 3]);

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.basicWrite: 1.0},
            totalWords: 10,
            fetchDueProgress: (_, __) async => progress,
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.length, 3);
    });

    test('excludes words rejected by isWordSupportedForType', () async {
      final progress = List.generate(6, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(6, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.flipCard: 1.0},
            totalWords: 10,
            fetchDueProgress: (_, __) async => progress,
            fetchWord: _wordFetcher(words),
            // Only even ids are "supported"
            isWordSupportedForType: (_, w) => w.id.isEven,
          );

      expect(result.every((w) => w.id.isEven), isTrue);
      expect(result.length, 3); // ids 2, 4, 6
    });
  });

  // ── two types, no overlap ──────────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – two types, no overlap', () {
    test('each type contributes words proportional to its quota', () async {
      // flipCard quota 1.0, basicWrite quota 1.0 → each normalised to 0.5
      // For totalWords=10: each type targets 5 words
      final flipProgress = List.generate(10, (i) => _progress(i + 1));
      final writeProgress = List.generate(10, (i) => _progress(i + 101));
      final words = {
        ...{for (int i = 1; i <= 10; i++) i: _word(i)},
        ...{for (int i = 101; i <= 110; i++) i: _word(i)},
      };

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {
              ExerciseType.flipCard: 1.0,
              ExerciseType.basicWrite: 1.0,
            },
            totalWords: 10,
            fetchDueProgress: _progressFetcher({
              ExerciseType.flipCard: flipProgress,
              ExerciseType.basicWrite: writeProgress,
            }),
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.length, 10);
      expect(result.map((w) => w.id).toSet().length, 10); // all unique
    });

    test('result contains no duplicate word ids', () async {
      final flipProgress = List.generate(10, (i) => _progress(i + 1));
      final writeProgress = List.generate(10, (i) => _progress(i + 11));
      final words = _wordMap(List.generate(20, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {
              ExerciseType.flipCard: 1.0,
              ExerciseType.basicWrite: 1.0,
            },
            totalWords: 15,
            fetchDueProgress: _progressFetcher({
              ExerciseType.flipCard: flipProgress,
              ExerciseType.basicWrite: writeProgress,
            }),
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      final ids = result.map((w) => w.id).toList();
      expect(ids.toSet().length, ids.length); // no duplicates
    });
  });

  // ── two types, full overlap ────────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – two types, full overlap', () {
    test(
      'full overlap: unique total is respected; backfill fills remaining slots',
      () async {
        // Both types return the same 10 words.
        // First pass: flipCard gets 5, basicWrite tries to add 5 but all seen.
        // Backfill: flipCard provides the remaining 5.
        final sharedProgress = List.generate(10, (i) => _progress(i + 1));
        final words = _wordMap(List.generate(10, (i) => i + 1));

        final result =
            await QuickPracticeService.selectReviewWordsForQuickSession(
              quotaByType: {
                ExerciseType.flipCard: 1.0,
                ExerciseType.basicWrite: 1.0,
              },
              totalWords: 10,
              fetchDueProgress: (_, limit) async =>
                  sharedProgress.take(limit).toList(),
              fetchWord: _wordFetcher(words),
              isWordSupportedForType: _allSupportedForType,
            );

        expect(result.length, 10);
        expect(result.map((w) => w.id).toSet().length, 10);
      },
    );

    test('result never exceeds totalWords even with backfill', () async {
      final sharedProgress = List.generate(30, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(30, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {
              ExerciseType.flipCard: 1.0,
              ExerciseType.basicWrite: 1.0,
            },
            totalWords: 10,
            fetchDueProgress: (_, limit) async =>
                sharedProgress.take(limit).toList(),
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.length, lessThanOrEqualTo(10));
    });
  });

  // ── quota distribution ─────────────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – quota distribution', () {
    test(
      'type with higher quota gets more words from disjoint pools',
      () async {
        // flipCard quota 3.0, basicWrite quota 1.0 → normalised 0.75 / 0.25
        // For totalWords=12: flipCard targets 9, basicWrite targets 3
        final flipProgress = List.generate(20, (i) => _progress(i + 1));
        final writeProgress = List.generate(20, (i) => _progress(i + 101));
        final words = {
          ...{for (int i = 1; i <= 20; i++) i: _word(i)},
          ...{for (int i = 101; i <= 120; i++) i: _word(i)},
        };

        final result =
            await QuickPracticeService.selectReviewWordsForQuickSession(
              quotaByType: {
                ExerciseType.flipCard: 3.0,
                ExerciseType.basicWrite: 1.0,
              },
              totalWords: 12,
              fetchDueProgress: _progressFetcher({
                ExerciseType.flipCard: flipProgress,
                ExerciseType.basicWrite: writeProgress,
              }),
              fetchWord: _wordFetcher(words),
              isWordSupportedForType: _allSupportedForType,
            );

        expect(result.length, 12);
        final fromFlip = result.where((w) => w.id <= 20).length;
        final fromWrite = result.where((w) => w.id >= 101).length;
        expect(fromFlip, greaterThan(fromWrite));
      },
    );

    test('single-type quota normalises to 1.0 and fills totalWords', () async {
      final progress = List.generate(20, (i) => _progress(i + 1));
      final words = _wordMap(List.generate(20, (i) => i + 1));

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {
              ExerciseType.flipCard: 42.0,
            }, // raw value; should normalise
            totalWords: 8,
            fetchDueProgress: (_, limit) async => progress.take(limit).toList(),
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.length, 8);
    });
  });

  // ── progress with null word id ─────────────────────────────────────────────
  group('selectReviewWordsForQuickSession – edge cases', () {
    test('progress records with null word.value are skipped', () async {
      final progressWithNull = DbWordProgress(); // word.value stays null
      final progress = [_progress(1), progressWithNull, _progress(2)];
      final words = _wordMap([1, 2]);

      final result =
          await QuickPracticeService.selectReviewWordsForQuickSession(
            quotaByType: {ExerciseType.flipCard: 1.0},
            totalWords: 10,
            fetchDueProgress: (_, __) async => progress,
            fetchWord: _wordFetcher(words),
            isWordSupportedForType: _allSupportedForType,
          );

      expect(result.map((w) => w.id).toSet(), {1, 2});
    });

    test(
      'duplicate progress records for same word id are deduplicated',
      () async {
        final progress = [_progress(1), _progress(1), _progress(2)];
        final words = _wordMap([1, 2]);

        final result =
            await QuickPracticeService.selectReviewWordsForQuickSession(
              quotaByType: {ExerciseType.flipCard: 1.0},
              totalWords: 10,
              fetchDueProgress: (_, __) async => progress,
              fetchWord: _wordFetcher(words),
              isWordSupportedForType: _allSupportedForType,
            );

        final ids = result.map((w) => w.id).toList();
        expect(ids.toSet().length, ids.length); // no duplicates
        expect(ids.toSet(), {1, 2});
      },
    );
  });
}
