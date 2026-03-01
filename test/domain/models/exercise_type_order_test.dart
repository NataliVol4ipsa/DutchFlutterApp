// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── learningOrder ──────────────────────────────────────────────────────────
  group('ExerciseTypeOrder.learningOrder', () {
    test('starts with flipCard', () {
      expect(ExerciseTypeOrder.learningOrder.first, ExerciseType.flipCard);
    });

    test('second step is basicWrite', () {
      expect(ExerciseTypeOrder.learningOrder[1], ExerciseType.basicWrite);
    });

    test('contains exactly two types', () {
      expect(ExerciseTypeOrder.learningOrder.length, 2);
    });
  });

  // ── masteryConsecutiveCorrect ──────────────────────────────────────────────
  group('ExerciseTypeOrder.masteryConsecutiveCorrect', () {
    test('equals 2', () {
      expect(ExerciseTypeOrder.masteryConsecutiveCorrect, 2);
    });
  });

  // ── nextType ───────────────────────────────────────────────────────────────
  group('ExerciseTypeOrder.nextType', () {
    test('flipCard → basicWrite', () {
      expect(
        ExerciseTypeOrder.nextType(ExerciseType.flipCard),
        ExerciseType.basicWrite,
      );
    });

    test('basicWrite → null (last in order)', () {
      expect(ExerciseTypeOrder.nextType(ExerciseType.basicWrite), isNull);
    });

    test('deHetPick → null (not in learning order)', () {
      expect(ExerciseTypeOrder.nextType(ExerciseType.deHetPick), isNull);
    });

    test('manyToMany → null (not in learning order)', () {
      expect(ExerciseTypeOrder.nextType(ExerciseType.manyToMany), isNull);
    });
  });

  // ── isTracked ──────────────────────────────────────────────────────────────
  group('ExerciseTypeOrder.isTracked', () {
    test('flipCard is tracked', () {
      expect(ExerciseTypeOrder.isTracked(ExerciseType.flipCard), isTrue);
    });

    test('basicWrite is tracked', () {
      expect(ExerciseTypeOrder.isTracked(ExerciseType.basicWrite), isTrue);
    });

    test('deHetPick is NOT tracked', () {
      expect(ExerciseTypeOrder.isTracked(ExerciseType.deHetPick), isFalse);
    });

    test('manyToMany is NOT tracked', () {
      expect(ExerciseTypeOrder.isTracked(ExerciseType.manyToMany), isFalse);
    });
  });
}
