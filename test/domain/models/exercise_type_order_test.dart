// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── triggers map ───────────────────────────────────────────────────────────
  group('ExerciseTypeOrder.triggers', () {
    test('contains exactly three tracked types', () {
      expect(ExerciseTypeOrder.triggers.length, 3);
    });

    test('flipCardDutchEnglish has no prerequisite (null trigger)', () {
      expect(
        ExerciseTypeOrder.triggers[ExerciseTypeDetailed.flipCardDutchEnglish],
        isNull,
      );
    });

    test(
      'flipCardEnglishDutch trigger requires 1 correct in flipCardDutchEnglish',
      () {
        final trigger = ExerciseTypeOrder
            .triggers[ExerciseTypeDetailed.flipCardEnglishDutch]!;
        expect(trigger.prerequisite, ExerciseTypeDetailed.flipCardDutchEnglish);
        expect(trigger.requiredCorrectAnswers, 1);
      },
    );

    test('basicWrite trigger requires 3 correct in flipCardDutchEnglish', () {
      final trigger =
          ExerciseTypeOrder.triggers[ExerciseTypeDetailed.basicWrite]!;
      expect(trigger.prerequisite, ExerciseTypeDetailed.flipCardDutchEnglish);
      expect(trigger.requiredCorrectAnswers, 3);
    });
  });

  // ── isTracked ──────────────────────────────────────────────────────────────
  group('ExerciseTypeOrder.isTracked', () {
    test('flipCardDutchEnglish is tracked', () {
      expect(
        ExerciseTypeOrder.isTracked(ExerciseTypeDetailed.flipCardDutchEnglish),
        isTrue,
      );
    });

    test('flipCardEnglishDutch is tracked', () {
      expect(
        ExerciseTypeOrder.isTracked(ExerciseTypeDetailed.flipCardEnglishDutch),
        isTrue,
      );
    });

    test('basicWrite is tracked', () {
      expect(
        ExerciseTypeOrder.isTracked(ExerciseTypeDetailed.basicWrite),
        isTrue,
      );
    });

    test('deHetPick is NOT tracked', () {
      expect(
        ExerciseTypeOrder.isTracked(ExerciseTypeDetailed.deHetPick),
        isFalse,
      );
    });
  });

  // ── getNewlyUnlockedTypes ──────────────────────────────────────────────────
  group('ExerciseTypeOrder.getNewlyUnlockedTypes', () {
    test('0 correct in Dutch-English → nothing unlocked', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.flipCardDutchEnglish,
        0,
      );
      expect(unlocked, isEmpty);
    });

    test('1 correct in Dutch-English → English-Dutch unlocked', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.flipCardDutchEnglish,
        1,
      );
      expect(unlocked, contains(ExerciseTypeDetailed.flipCardEnglishDutch));
      expect(unlocked, isNot(contains(ExerciseTypeDetailed.basicWrite)));
    });

    test('2 correct in Dutch-English → only English-Dutch unlocked', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.flipCardDutchEnglish,
        2,
      );
      expect(unlocked, contains(ExerciseTypeDetailed.flipCardEnglishDutch));
      expect(unlocked, isNot(contains(ExerciseTypeDetailed.basicWrite)));
    });

    test(
      '3 correct in Dutch-English → both English-Dutch and basicWrite unlocked',
      () {
        final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
          ExerciseTypeDetailed.flipCardDutchEnglish,
          3,
        );
        expect(
          unlocked,
          containsAll([
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
          ]),
        );
      },
    );

    test(
      '5 correct in Dutch-English → both English-Dutch and basicWrite (≥ threshold)',
      () {
        final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
          ExerciseTypeDetailed.flipCardDutchEnglish,
          5,
        );
        expect(unlocked.length, 2);
      },
    );

    test('correct answers in English-Dutch do not unlock anything', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.flipCardEnglishDutch,
        10,
      );
      expect(unlocked, isEmpty);
    });

    test('correct answers in basicWrite do not unlock anything', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.basicWrite,
        10,
      );
      expect(unlocked, isEmpty);
    });

    test('correct answers in deHetPick do not unlock anything', () {
      final unlocked = ExerciseTypeOrder.getNewlyUnlockedTypes(
        ExerciseTypeDetailed.deHetPick,
        10,
      );
      expect(unlocked, isEmpty);
    });
  });
}
