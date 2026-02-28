// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/services/spaced_repetition_algorithm.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── calculateNewEasinessFactor ────────────────────────────────────────────
  group('SpacedRepetitionAlgorithm.calculateNewEasinessFactor', () {
    // Delta formula: 0.1 - (5-q) * (0.08 + (5-q) * 0.02)

    test('quality=5 (perfect recall) increases EF by 0.1', () {
      // delta = 0.1 - 0 * (...) = 0.1
      const ef = 2.0;
      expect(
        SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 5),
        closeTo(2.1, 1e-9),
      );
    });

    test('quality=4 (good) keeps EF unchanged (delta=0)', () {
      // delta = 0.1 - 1*(0.08 + 1*0.02) = 0.1 - 0.10 = 0.0
      const ef = 2.0;
      expect(
        SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 4),
        closeTo(2.0, 1e-9),
      );
    });

    test('quality=2 (hard / AnkiGrade.hard) decreases EF by 0.32', () {
      // delta = 0.1 - 3*(0.08 + 3*0.02) = 0.1 - 3*0.14 = -0.32
      const ef = 2.5;
      expect(
        SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 2),
        closeTo(2.18, 1e-9),
      );
    });

    test('quality=1 (again / AnkiGrade.again) decreases EF by 0.54', () {
      // delta = 0.1 - 4*(0.08 + 4*0.02) = 0.1 - 0.64 = -0.54
      const ef = 2.5;
      expect(
        SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 1),
        closeTo(1.96, 1e-9),
      );
    });

    test(
      'result is clamped at minEasinessFactor=1.3 when quality is very low',
      () {
        // quality=1 with ef=1.5: 1.5 - 0.54 = 0.96  →  clamped to 1.3
        const ef = 1.5;
        expect(
          SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 1),
          SpacedRepetitionAlgorithm.minEasinessFactor,
        );
      },
    );

    test(
      'result is clamped at maxEasinessFactor=2.5 when ef is already high',
      () {
        // quality=5 with ef=2.5: 2.5 + 0.1 = 2.6  →  clamped to 2.5
        const ef = 2.5;
        expect(
          SpacedRepetitionAlgorithm.calculateNewEasinessFactor(ef, 5),
          SpacedRepetitionAlgorithm.maxEasinessFactor,
        );
      },
    );
  });

  // ── calculateNewIntervalDays ──────────────────────────────────────────────
  group('SpacedRepetitionAlgorithm.calculateNewIntervalDays', () {
    test('mistake always resets interval to 1 day', () {
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(true, 0, 2.5, 30),
        1,
      );
    });

    test('first correct answer (consecutive=1) → 1 day', () {
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 1, 2.5, 1),
        1,
      );
    });

    test('second correct answer (consecutive=2) → 6 days', () {
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 2, 2.5, 1),
        6,
      );
    });

    test('third consecutive correct answer uses EF multiplier', () {
      // round(6 * 2.5) = round(15.0) = 15
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 3, 2.5, 6),
        15,
      );
    });

    test('anki "easy" grade applies an additional ×1.3 multiplier', () {
      // round(6 * 2.5 * 1.3) = round(19.5) = 20
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(
          false,
          3,
          2.5,
          6,
          isAnkiEasy: true,
        ),
        20,
      );
    });

    test('lower EF produces a shorter interval', () {
      // round(15 * 2.0) = 30
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 4, 2.0, 15),
        30,
      );
    });

    test('interval is capped at 365 days', () {
      // round(200 * 2.5) = 500 → clamped to 365
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 10, 2.5, 200),
        365,
      );
    });

    test('interval never drops below 1 day', () {
      expect(
        SpacedRepetitionAlgorithm.calculateNewIntervalDays(false, 3, 1.3, 0),
        1,
      );
    });
  });
}
