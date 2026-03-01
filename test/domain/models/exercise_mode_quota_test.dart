// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/models/exercise_mode_quota.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── activeTypes ────────────────────────────────────────────────────────────
  group('ExerciseModeQuota.activeTypes', () {
    test('flipCardOnly contains only flipCard', () {
      expect(ExerciseModeQuota.flipCardOnly.activeTypes, [
        ExerciseType.flipCard,
      ]);
    });

    test('flipCardAndWriting contains flipCard and basicWrite', () {
      expect(
        ExerciseModeQuota.flipCardAndWriting.activeTypes,
        containsAll([ExerciseType.flipCard, ExerciseType.basicWrite]),
      );
      expect(ExerciseModeQuota.flipCardAndWriting.activeTypes.length, 2);
    });

    test('zero-weight type is excluded from activeTypes', () {
      const quota = ExerciseModeQuota({
        ExerciseType.flipCard: 1.0,
        ExerciseType.basicWrite: 0.0,
      });
      expect(quota.activeTypes, [ExerciseType.flipCard]);
    });

    test('empty quota has empty activeTypes', () {
      expect(const ExerciseModeQuota({}).activeTypes, isEmpty);
    });
  });

  // ── activeDetailedTypes ────────────────────────────────────────────────────
  group('ExerciseModeQuota.activeDetailedTypes', () {
    test('flipCardOnly → only flipCardDutchEnglish, no basicWrite', () {
      final detailed = ExerciseModeQuota.flipCardOnly.activeDetailedTypes;
      expect(detailed, contains(ExerciseTypeDetailed.flipCardDutchEnglish));
      expect(detailed, isNot(contains(ExerciseTypeDetailed.basicWrite)));
    });

    test(
      'flipCardAndWriting → contains both flipCardDutchEnglish and basicWrite',
      () {
        final detailed =
            ExerciseModeQuota.flipCardAndWriting.activeDetailedTypes;
        expect(
          detailed,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.basicWrite,
          ]),
        );
      },
    );

    test('no duplicates in activeDetailedTypes', () {
      final detailed = ExerciseModeQuota.flipCardAndWriting.activeDetailedTypes;
      expect(detailed.toSet().length, detailed.length);
    });

    test('empty quota → empty activeDetailedTypes', () {
      expect(const ExerciseModeQuota({}).activeDetailedTypes, isEmpty);
    });
  });
}
