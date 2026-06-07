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

    test(
      'allModesQuota contains flipCard, flipCardReverse, basicWrite, and audioDictation',
      () {
        expect(
          ExerciseModeQuota.allModesQuota.activeTypes,
          containsAll([
            ExerciseType.flipCard,
            ExerciseType.flipCardReverse,
            ExerciseType.basicWrite,
            ExerciseType.audioDictation,
          ]),
        );
        expect(ExerciseModeQuota.allModesQuota.activeTypes.length, 4);
      },
    );

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
      'allModesQuota → contains flipCardDutchEnglish, flipCardEnglishDutch, basicWrite, and audioDictation',
      () {
        final detailed = ExerciseModeQuota.allModesQuota.activeDetailedTypes;
        expect(
          detailed,
          containsAll([
            ExerciseTypeDetailed.flipCardDutchEnglish,
            ExerciseTypeDetailed.flipCardEnglishDutch,
            ExerciseTypeDetailed.basicWrite,
            ExerciseTypeDetailed.audioDictation,
          ]),
        );
      },
    );

    test('no duplicates in activeDetailedTypes', () {
      final detailed = ExerciseModeQuota.allModesQuota.activeDetailedTypes;
      expect(detailed.toSet().length, detailed.length);
    });

    test('empty quota → empty activeDetailedTypes', () {
      expect(const ExerciseModeQuota({}).activeDetailedTypes, isEmpty);
    });
  });
}
