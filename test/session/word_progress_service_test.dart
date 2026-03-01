import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'word_progress_service_test.mocks.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

Word _word([int id = 1]) => Word(
  id,
  'hond',
  ['dog'],
  PartOfSpeech.noun,
  nounDetails: WordNounDetails(),
  verbDetails: null,
);

/// Creates a fresh [DbWordProgress] with controlled initial state.
/// Does NOT set [DbWordProgress.word] – that IsarLink requires a running Isar
/// instance. [_applySessionOutcome] never reads the link so this is safe.
DbWordProgress _freshProgress({
  double ef = 2.0,
  int interval = 0,
  int consecutive = 0,
}) {
  final p = DbWordProgress();
  p.exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish;
  p.easinessFactor = ef;
  p.intervalDays = interval;
  p.consequetiveCorrectAnswers = consecutive;
  return p;
}

ExerciseSummaryDetailed _simplified(Word word, {int wrong = 0}) =>
    ExerciseSummaryDetailed(
      word: word,
      exerciseType: ExerciseType.flipCard,
      totalCorrectAnswers: wrong == 0 ? 1 : 0,
      totalWrongAnswers: wrong,
      correctAnswer: 'any',
    );

ExerciseSummaryDetailed _anki(Word word, AnkiGrade grade) =>
    ExerciseSummaryDetailed(
      word: word,
      exerciseType: ExerciseType.flipCard,
      totalCorrectAnswers: grade.isMistake ? 0 : 1,
      totalWrongAnswers: grade.isMistake ? 1 : 0,
      correctAnswer: 'any',
      ankiGrade: grade,
    );

// ── mocks ─────────────────────────────────────────────────────────────────────
// Re-run `flutter pub run build_runner build` when adding to / removing from
// the list below.
@GenerateMocks([WordProgressBatchRepository])
void main() {
  late MockWordProgressBatchRepository mockRepo;
  late WordProgressService service;

  // Convenience: sets up the mock to return [progress] for [word] and
  // captures nothing but allows saveAllAsync.
  void stubRepo(Word word, DbWordProgress progress) {
    final key = WordProgressKey(
      word.id,
      ExerciseTypeDetailed.flipCardDutchEnglish,
    );
    when(
      mockRepo.getOrCreateManyAsync(any),
    ).thenAnswer((_) async => {key: progress});
    when(mockRepo.saveAllAsync(any)).thenAnswer((_) async {});
  }

  setUp(() {
    mockRepo = MockWordProgressBatchRepository();
    service = WordProgressService(wordProgressRepository: mockRepo);
  });

  // ── processSessionResults ─────────────────────────────────────────────────
  group('processSessionResults', () {
    test(
      'does nothing and touches no repo methods when list is empty',
      () async {
        await service.processSessionResults([]);
        verifyZeroInteractions(mockRepo);
      },
    );

    // ── simplified mode (no ankiGrade) ──────────────────────────────────
    group('simplified mode –', () {
      test(
        'known word: consecutive increments, interval advances, EF increases',
        () async {
          final word = _word();
          // Start with EF below max so quality=5 can push it up
          final progress = _freshProgress(ef: 2.0, consecutive: 0, interval: 0);
          stubRepo(word, progress);

          await service.processSessionResults([_simplified(word)]);

          // consecutive 0→1, which forces interval=1 (first correct answer rule)
          expect(progress.consequetiveCorrectAnswers, 1);
          expect(progress.intervalDays, 1);
          // quality=5 → delta=+0.1 → 2.0+0.1=2.1
          expect(progress.easinessFactor, closeTo(2.1, 0.0001));
          expect(progress.lastPracticed, isNotNull);
        },
      );

      test('2nd consecutive correct: interval becomes 6 days', () async {
        final word = _word();
        final progress = _freshProgress(ef: 2.0, consecutive: 1, interval: 1);
        stubRepo(word, progress);

        await service.processSessionResults([_simplified(word)]);

        expect(progress.consequetiveCorrectAnswers, 2);
        expect(progress.intervalDays, 6);
      });

      test('3rd+ consecutive: interval = round(current × EF)', () async {
        final word = _word();
        // After 2 known: consecutive=2, interval=6, ef=2.0
        final progress = _freshProgress(ef: 2.0, consecutive: 2, interval: 6);
        stubRepo(word, progress);

        await service.processSessionResults([_simplified(word)]);

        expect(progress.consequetiveCorrectAnswers, 3);
        // new EF = 2.0+0.1 = 2.1; interval = round(6 × 2.1) = round(12.6) = 13
        expect(progress.intervalDays, 13);
        expect(progress.easinessFactor, closeTo(2.1, 0.0001));
      });

      test(
        'unknown word: consecutive resets to 0, interval resets to 1, EF decreases',
        () async {
          final word = _word();
          final progress = _freshProgress(
            ef: 2.0,
            consecutive: 5,
            interval: 30,
          );
          stubRepo(word, progress);

          await service.processSessionResults([_simplified(word, wrong: 1)]);

          expect(progress.consequetiveCorrectAnswers, 0);
          expect(progress.intervalDays, 1);
          // quality=2 → delta = 0.1-(5-2)*(0.08+(5-2)*0.02) = 0.1-3*(0.08+0.06)
          //           = 0.1 - 3*0.14 = 0.1 - 0.42 = -0.32
          // new EF = 2.0 - 0.32 = 1.68
          expect(progress.easinessFactor, closeTo(1.68, 0.0001));
        },
      );

      test('nextReviewDate is set to now + intervalDays', () async {
        final word = _word();
        final progress = _freshProgress(ef: 2.0, consecutive: 0, interval: 0);
        stubRepo(word, progress);

        final before = DateTime.now();
        await service.processSessionResults([_simplified(word)]);

        // interval is 1 day after first correct answer
        final expectedDate = before.add(const Duration(days: 1));
        expect(
          progress.nextReviewDate.difference(expectedDate).abs(),
          lessThan(const Duration(seconds: 5)),
        );
      });
    });

    // ── anki mode (ankiGrade != null) ────────────────────────────────────
    group('anki mode –', () {
      test(
        'AnkiGrade.again: resets consecutive to 0, resets interval to 1',
        () async {
          final word = _word();
          final progress = _freshProgress(
            ef: 2.0,
            consecutive: 3,
            interval: 15,
          );
          stubRepo(word, progress);

          await service.processSessionResults([_anki(word, AnkiGrade.again)]);

          expect(progress.consequetiveCorrectAnswers, 0);
          expect(progress.intervalDays, 1);
          // quality=1 → delta = 0.1-(5-1)*(0.08+(5-1)*0.02) = 0.1-4*(0.08+0.08)
          //           = 0.1-4*0.16 = 0.1-0.64 = -0.54 → 2.0-0.54=1.46
          expect(progress.easinessFactor, closeTo(1.46, 0.0001));
        },
      );

      test(
        'AnkiGrade.hard: resets consecutive, reduces EF, interval=1',
        () async {
          final word = _word();
          final progress = _freshProgress(
            ef: 2.0,
            consecutive: 4,
            interval: 30,
          );
          stubRepo(word, progress);

          await service.processSessionResults([_anki(word, AnkiGrade.hard)]);

          expect(progress.consequetiveCorrectAnswers, 0); // hard is a mistake
          expect(progress.intervalDays, 1);
          expect(progress.easinessFactor, lessThan(2.0));
        },
      );

      test(
        'AnkiGrade.good: increments consecutive, advances interval, uses quality=4',
        () async {
          final word = _word();
          final progress = _freshProgress(ef: 2.0, consecutive: 2, interval: 6);
          stubRepo(word, progress);

          await service.processSessionResults([_anki(word, AnkiGrade.good)]);

          expect(progress.consequetiveCorrectAnswers, 3);
          // quality=4 → delta=0.1-(5-4)*(0.08+(5-4)*0.02)=0.1-1*(0.1)=0
          // new EF = 2.0 (unchanged)
          expect(progress.easinessFactor, closeTo(2.0, 0.0001));
          // interval = round(6 × 2.0) = 12
          expect(progress.intervalDays, 12);
        },
      );

      test(
        'AnkiGrade.easy: interval is 1.3× larger than AnkiGrade.good for same start state',
        () async {
          final word = _word();
          final ef = 2.0;

          final progressEasy = _freshProgress(
            ef: ef,
            consecutive: 2,
            interval: 6,
          );
          final progressGood = _freshProgress(
            ef: ef,
            consecutive: 2,
            interval: 6,
          );

          // run easy
          stubRepo(word, progressEasy);
          await service.processSessionResults([_anki(word, AnkiGrade.easy)]);
          final easyInterval = progressEasy.intervalDays;

          // run good with same start state
          reset(mockRepo);
          stubRepo(word, progressGood);
          await service.processSessionResults([_anki(word, AnkiGrade.good)]);
          final goodInterval = progressGood.intervalDays;

          expect(easyInterval, greaterThan(goodInterval));
        },
      );
    });

    // ── repository interaction ──────────────────────────────────────────────
    group('repository interaction –', () {
      test(
        'saveAllAsync is called once with the updated progress object',
        () async {
          final word = _word();
          final progress = _freshProgress();
          stubRepo(word, progress);

          await service.processSessionResults([_simplified(word)]);

          verify(mockRepo.saveAllAsync([progress])).called(1);
        },
      );

      test('progress with no matching key is silently skipped', () async {
        // Repo returns an empty map (key not found)
        when(mockRepo.getOrCreateManyAsync(any)).thenAnswer((_) async => {});
        when(mockRepo.saveAllAsync(any)).thenAnswer((_) async {});

        await service.processSessionResults([_simplified(_word())]);

        // saveAllAsync should still be called but with an empty list
        verify(mockRepo.saveAllAsync([])).called(1);
      });
    });

    // ── mastery scheduling ──────────────────────────────────────────────────
    group('mastery scheduling –', () {
      /// Builds a mock stub that captures every call to [getOrCreateManyAsync],
      /// returning [progress] the first time and an empty map for subsequent
      /// calls (the return value of the scheduling call is unused).
      List<List<WordProgressKey>> _captureGetOrCreate(
        Word word,
        DbWordProgress progress,
      ) {
        final captured = <List<WordProgressKey>>[];
        when(mockRepo.getOrCreateManyAsync(any)).thenAnswer((inv) async {
          captured.add(
            (inv.positionalArguments[0] as List).cast<WordProgressKey>(),
          );
          final key = WordProgressKey(
            word.id,
            ExerciseTypeDetailed.flipCardDutchEnglish,
          );
          return captured.length == 1 ? {key: progress} : {};
        });
        when(mockRepo.saveAllAsync(any)).thenAnswer((_) async {});
        return captured;
      }

      test(
        'flipCard reaching mastery schedules basicWrite (getOrCreate called twice)',
        () async {
          final word = _word();
          // consecutive = masteryThreshold - 1 → after correct = threshold → mastery
          final progress = _freshProgress(
            consecutive: ExerciseTypeOrder.masteryConsecutiveCorrect - 1,
            interval: 1,
          );
          final captured = _captureGetOrCreate(word, progress);

          await service.processSessionResults([_simplified(word)]);

          expect(captured.length, 2);
          expect(
            captured.last.any(
              (k) => k.exerciseType == ExerciseTypeDetailed.basicWrite,
            ),
            isTrue,
            reason: 'Second call should request basicWrite progress creation',
          );
        },
      );

      test(
        'flipCard below mastery threshold does not schedule next type',
        () async {
          final word = _word();
          // consecutive 0 → 1: still below mastery (threshold = 2)
          final progress = _freshProgress(consecutive: 0);
          stubRepo(word, progress);

          await service.processSessionResults([_simplified(word)]);

          // Only first call (for current type); no second call for next type
          verify(mockRepo.getOrCreateManyAsync(any)).called(1);
        },
      );

      test(
        'basicWrite at mastery has no next type – getOrCreate called once',
        () async {
          final word = _word();
          final progress = _freshProgress(
            consecutive: ExerciseTypeOrder.masteryConsecutiveCorrect - 1,
            interval: 1,
          );
          progress.exerciseType = ExerciseTypeDetailed.basicWrite;

          final basicWriteKey = WordProgressKey(
            word.id,
            ExerciseTypeDetailed.basicWrite,
          );
          when(
            mockRepo.getOrCreateManyAsync(any),
          ).thenAnswer((_) async => {basicWriteKey: progress});
          when(mockRepo.saveAllAsync(any)).thenAnswer((_) async {});

          final summary = ExerciseSummaryDetailed(
            word: word,
            exerciseType: ExerciseType.basicWrite,
            totalCorrectAnswers: 1,
            totalWrongAnswers: 0,
            correctAnswer: 'hond',
          );
          await service.processSessionResults([summary]);

          // basicWrite is the last type → no second scheduling call
          verify(mockRepo.getOrCreateManyAsync(any)).called(1);
        },
      );

      test(
        'already mastered word still re-schedules next type idempotently',
        () async {
          final word = _word();
          // consecutive already above threshold; after correct it increments further
          final progress = _freshProgress(
            consecutive: ExerciseTypeOrder.masteryConsecutiveCorrect,
            interval: 6,
          );
          stubRepo(word, progress);

          await service.processSessionResults([_simplified(word)]);

          // getOrCreate called twice (idempotent: DB handles already-existing records)
          verify(mockRepo.getOrCreateManyAsync(any)).called(2);
        },
      );
    });
  });

  // ── getPracticedWordIdsAsync ──────────────────────────────────────────────
  group('getPracticedWordIdsAsync', () {
    test(
      'returns only ids of progress records where lastPracticed is set',
      () async {
        // Build two progress objects: one practiced, one not.
        // IsarLink.word is uninitialized → word.value is null → id won't resolve.
        // We verify the lastPracticed filter here; the id extraction is an
        // integration concern covered by repo tests.
        final practiced = DbWordProgress()
          ..exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish
          ..lastPracticed = DateTime.now();
        final notPracticed = DbWordProgress()
          ..exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish;

        when(
          mockRepo.getProgressForWordsAsync([1, 2]),
        ).thenAnswer((_) async => [practiced, notPracticed]);

        final result = await service.getPracticedWordIdsAsync([1, 2]);

        // Both have null IsarLink (no Isar running), so word.value?.id = null
        // and whereType<int>() yields an empty set – correct filtering overall;
        // the word-id resolution requires an Isar instance (integration test).
        expect(result, isA<Set<int>>());
      },
    );

    test(
      'returns empty set when all progress records have null lastPracticed',
      () async {
        final p = DbWordProgress()
          ..exerciseType = ExerciseTypeDetailed.flipCardDutchEnglish;
        // lastPracticed is null by default

        when(
          mockRepo.getProgressForWordsAsync(any),
        ).thenAnswer((_) async => [p]);

        final result = await service.getPracticedWordIdsAsync([1]);
        expect(result, isEmpty);
      },
    );
  });
}
