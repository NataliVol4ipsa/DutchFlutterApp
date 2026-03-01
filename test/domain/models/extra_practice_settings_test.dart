// ignore_for_file: avoid_relative_lib_imports

import 'package:dutch_app/domain/models/settings.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ── normalizedWeights ─────────────────────────────────────────────────────
  group('ExtraPracticeSettings.normalizedWeights', () {
    test('returns empty map when no buckets are selected', () {
      final settings = ExtraPracticeSettings(
        useWeakestWords: false,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );
      expect(settings.normalizedWeights, isEmpty);
    });

    test('single bucket selected → weight is 1.0', () {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: false,
      );
      final w = settings.normalizedWeights;
      expect(w.length, 1);
      expect(w[ExtraPracticeBucket.weakest], closeTo(1.0, 1e-9));
    });

    test('two buckets: weakest + random → proportional to raw weights', () {
      // raw: weakest=0.5, random=0.1  →  sum=0.6
      // normalized: weakest=5/6≈0.8333, random=1/6≈0.1667
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: false,
        useRecentlyLearned: false,
        useRandomWords: true,
      );
      final w = settings.normalizedWeights;
      expect(w.length, 2);
      expect(w[ExtraPracticeBucket.weakest], closeTo(5 / 6, 1e-9));
      expect(w[ExtraPracticeBucket.random], closeTo(1 / 6, 1e-9));
    });

    test('two buckets: tomorrow + recentlyLearned → proportional', () {
      // raw: tomorrow=0.25, recentlyLearned=0.15  → sum=0.40
      // normalized: tomorrow=0.625, recentlyLearned=0.375
      final settings = ExtraPracticeSettings(
        useWeakestWords: false,
        useTomorrowsWords: true,
        useRecentlyLearned: true,
        useRandomWords: false,
      );
      final w = settings.normalizedWeights;
      expect(w.length, 2);
      expect(w[ExtraPracticeBucket.tomorrow], closeTo(0.25 / 0.40, 1e-9));
      expect(
        w[ExtraPracticeBucket.recentlyLearned],
        closeTo(0.15 / 0.40, 1e-9),
      );
    });

    test('all four buckets → weights sum to 1.0', () {
      final settings = ExtraPracticeSettings(
        useWeakestWords: true,
        useTomorrowsWords: true,
        useRecentlyLearned: true,
        useRandomWords: true,
      );
      final w = settings.normalizedWeights;
      expect(w.length, 4);
      final total = w.values.fold(0.0, (a, b) => a + b);
      expect(total, closeTo(1.0, 1e-9));
    });

    test(
      'all four buckets → weakest has highest and random has lowest weight',
      () {
        final settings = ExtraPracticeSettings(
          useWeakestWords: true,
          useTomorrowsWords: true,
          useRecentlyLearned: true,
          useRandomWords: true,
        );
        final w = settings.normalizedWeights;
        expect(
          w[ExtraPracticeBucket.weakest],
          greaterThan(w[ExtraPracticeBucket.tomorrow]!),
        );
        expect(
          w[ExtraPracticeBucket.tomorrow],
          greaterThan(w[ExtraPracticeBucket.recentlyLearned]!),
        );
        expect(
          w[ExtraPracticeBucket.recentlyLearned],
          greaterThan(w[ExtraPracticeBucket.random]!),
        );
      },
    );

    test('default constructor enables weakest and tomorrow', () {
      final settings = ExtraPracticeSettings();
      expect(settings.hasAnySelected, isTrue);
      final w = settings.normalizedWeights;
      expect(w.containsKey(ExtraPracticeBucket.weakest), isTrue);
      expect(w.containsKey(ExtraPracticeBucket.tomorrow), isTrue);
      expect(w.containsKey(ExtraPracticeBucket.recentlyLearned), isFalse);
      expect(w.containsKey(ExtraPracticeBucket.random), isFalse);
    });
  });

  // ── hasAnySelected ─────────────────────────────────────────────────────────
  group('ExtraPracticeSettings.hasAnySelected', () {
    test('false when nothing selected', () {
      expect(
        ExtraPracticeSettings(
          useWeakestWords: false,
          useTomorrowsWords: false,
          useRecentlyLearned: false,
          useRandomWords: false,
        ).hasAnySelected,
        isFalse,
      );
    });

    test('true when only one option is selected', () {
      expect(
        ExtraPracticeSettings(
          useWeakestWords: false,
          useTomorrowsWords: false,
          useRecentlyLearned: true,
          useRandomWords: false,
        ).hasAnySelected,
        isTrue,
      );
    });
  });
}
