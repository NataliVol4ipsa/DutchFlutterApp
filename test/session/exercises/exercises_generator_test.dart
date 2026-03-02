import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/services/quick_practice_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/exercises/exercises_generator.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_english_dutch_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

// ── helpers ───────────────────────────────────────────────────────────────────

Word _word(int id) => Word(
  id,
  'hond',
  ['dog'],
  PartOfSpeech.noun,
  nounDetails: WordNounDetails(),
  verbDetails: null,
);

/// Builds a [DbWordProgress] without an Isar link (safe for pure-dart tests).
DbWordProgress _progress(
  ExerciseTypeDetailed type, {
  int consecutiveCorrect = 0,
}) {
  final p = DbWordProgress();
  p.exerciseType = type;
  // Use the scheduled-review track; exercises_generator checks the sum of both
  // tracks via ExerciseTypeOrder.unlockedTypesForWord.
  p.scheduledPracticeCorrectAnswerStreak = consecutiveCorrect;
  return p;
}

/// Builds a generator with all three exercise types active.
ExercisesGenerator _generator(
  List<Word> words, {
  Map<int, Set<ExerciseTypeDetailed>>? unlockedTypesById,
}) => ExercisesGenerator(
  [
    ExerciseType.flipCard,
    ExerciseType.flipCardReverse,
    ExerciseType.basicWrite,
  ],
  words,
  false,
  unlockedTypesById: unlockedTypesById,
);

// ── ExerciseTypeOrder.unlockedTypesForWord ────────────────────────────────────

void main() {
  group('ExerciseTypeOrder.unlockedTypesForWord', () {
    test(
      'brand-new word (no progress) → only flipCardDutchEnglish unlocked',
      () {
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({});
        expect(unlocked, {ExerciseTypeDetailed.flipCardDutchEnglish});
      },
    );

    test(
      '1 consecutive correct on flipCardDutchEnglish → also unlocks flipCardEnglishDutch',
      () {
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({
          ExerciseTypeDetailed.flipCardDutchEnglish: 1,
        });
        expect(
          unlocked,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          ]),
        );
        expect(unlocked, isNot(contains(ExerciseTypeDetailed.basicWrite)));
      },
    );

    test(
      '3 consecutive correct on flipCardDutchEnglish → all three types unlocked',
      () {
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({
          ExerciseTypeDetailed.flipCardDutchEnglish: 3,
        });
        expect(
          unlocked,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
          ]),
        );
      },
    );

    test(
      '2 consecutive correct → flipCard + flipCardReverse but NOT write',
      () {
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({
          ExerciseTypeDetailed.flipCardDutchEnglish: 2,
        });
        expect(unlocked, contains(ExerciseTypeDetailed.flipCardEnglishDutch));
        expect(unlocked, isNot(contains(ExerciseTypeDetailed.basicWrite)));
      },
    );

    test(
      'consecutive reset to 0 but type record exists → type stays unlocked',
      () {
        // Simulates a mistake after unlock: consecutive resets, but the DB
        // record for flipCardEnglishDutch and basicWrite both exist.
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({
          ExerciseTypeDetailed.flipCardDutchEnglish: 0,
          // Records exist for these types → they stay unlocked.
          ExerciseTypeDetailed.flipCardEnglishDutch: 0,
          ExerciseTypeDetailed.basicWrite: 0,
        });
        expect(
          unlocked,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
          ]),
          reason: 'established types must not be re-locked after a mistake',
        );
      },
    );

    test(
      'flipCardEnglishDutch record exists but consecutive 0 → stays unlocked',
      () {
        final unlocked = ExerciseTypeOrder.unlockedTypesForWord({
          ExerciseTypeDetailed.flipCardDutchEnglish: 0,
          ExerciseTypeDetailed.flipCardEnglishDutch: 0,
        });
        expect(unlocked, contains(ExerciseTypeDetailed.flipCardEnglishDutch));
        // basicWrite has no record and prerequisite count 0 → still locked.
        expect(unlocked, isNot(contains(ExerciseTypeDetailed.basicWrite)));
      },
    );
  });

  // ── QuickPracticeService.computeUnlockedTypesPerWord ───────────────────────

  group('QuickPracticeService.computeUnlockedTypesPerWord', () {
    test('word with no progress records → only base type unlocked', () {
      final result = QuickPracticeService.computeUnlockedTypesPerWord(
        [1],
        {1: []},
      );
      expect(result[1], {ExerciseTypeDetailed.flipCardDutchEnglish});
    });

    test('word with 1 consecutive correct → flipCard + flipCardReverse', () {
      final result = QuickPracticeService.computeUnlockedTypesPerWord(
        [1],
        {
          1: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 1,
            ),
          ],
        },
      );
      expect(
        result[1],
        containsAll([
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
        ]),
      );
    });

    test('multiple words computed independently', () {
      final result = QuickPracticeService.computeUnlockedTypesPerWord(
        [1, 2, 3],
        {
          1: [], // new
          2: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 1,
            ),
          ],
          3: [
            _progress(
              ExerciseTypeDetailed.flipCardDutchEnglish,
              consecutiveCorrect: 3,
            ),
          ],
        },
      );
      expect(result[1], {ExerciseTypeDetailed.flipCardDutchEnglish});
      expect(
        result[2],
        containsAll([
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
        ]),
      );
      expect(
        result[3],
        containsAll([
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
          ExerciseTypeDetailed.basicWrite,
        ]),
      );
    });
  });

  // ── ExercisesGenerator with unlockedTypesById ─────────────────────────────

  group('ExercisesGenerator — exercise type unlock enforcement', () {
    test(
      'brand-new word gets only flipCard exercise even when all types active',
      () {
        final word = _word(1);
        final unlocked = {
          1: {ExerciseTypeDetailed.flipCardDutchEnglish},
        };

        final exercises = _generator([
          word,
        ], unlockedTypesById: unlocked).generateExcercises();

        expect(exercises, hasLength(1));
        expect(exercises.first, isA<FlipCardExercise>());
      },
    );

    test(
      'word with 1 consecutive correct gets flipCard + flipCardReverse exercises',
      () {
        final word = _word(1);
        final unlocked = {
          1: {
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
          },
        };

        final exercises = _generator([
          word,
        ], unlockedTypesById: unlocked).generateExcercises();

        expect(exercises, hasLength(2));
        expect(
          exercises.map((e) => e.runtimeType),
          containsAll([FlipCardExercise, FlipCardEnglishDutchExercise]),
        );
      },
    );

    test('word with 3 consecutive correct gets all three exercise types', () {
      final word = _word(1);
      final unlocked = {
        1: {
          ExerciseTypeDetailed.flipCardDutchEnglish,
          ExerciseTypeDetailed.flipCardEnglishDutch,
          ExerciseTypeDetailed.basicWrite,
        },
      };

      final exercises = _generator([
        word,
      ], unlockedTypesById: unlocked).generateExcercises();

      expect(exercises, hasLength(3));
      expect(
        exercises.map((e) => e.runtimeType),
        containsAll([
          FlipCardExercise,
          FlipCardEnglishDutchExercise,
          WriteExercise,
        ]),
      );
    });

    test(
      'mixed new and practiced words in same session get correct exercises each',
      () {
        final newWord = _word(1); // only flipCard
        final practicedWord = _word(2); // flipCard + flipCardReverse + write

        final unlocked = {
          1: {ExerciseTypeDetailed.flipCardDutchEnglish},
          2: {
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
          },
        };

        final exercises = _generator([
          newWord,
          practicedWord,
        ], unlockedTypesById: unlocked).generateExcercises();

        // newWord: 1 exercise (flipCard only)
        // practicedWord: 3 exercises (flipCard + flipCardReverse + write)
        // total = 4
        expect(exercises, hasLength(4));
        expect(exercises.whereType<FlipCardExercise>(), hasLength(2));
        expect(
          exercises.whereType<FlipCardEnglishDutchExercise>(),
          hasLength(1),
        );
        expect(exercises.whereType<WriteExercise>(), hasLength(1));
      },
    );

    test('null unlockedTypesById allows all exercise types for all words', () {
      final word = _word(1);

      final exercises = _generator([
        word,
      ], unlockedTypesById: null).generateExcercises();

      // No restriction → all 3 exercise types generated
      expect(exercises, hasLength(3));
    });
  });
}
