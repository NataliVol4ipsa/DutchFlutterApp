import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WriteExercise.levenshteinDistance', () {
    // ── boundary cases ────────────────────────────────────────────────────────

    test('both strings empty → 0', () {
      expect(WriteExercise.levenshteinDistance('', ''), 0);
    });

    test('first string empty → length of second', () {
      expect(WriteExercise.levenshteinDistance('', 'abc'), 3);
    });

    test('second string empty → length of first', () {
      expect(WriteExercise.levenshteinDistance('abc', ''), 3);
    });

    test('identical strings → 0', () {
      expect(WriteExercise.levenshteinDistance('hond', 'hond'), 0);
    });

    test('single-char identical → 0', () {
      expect(WriteExercise.levenshteinDistance('a', 'a'), 0);
    });

    test('single-char different → 1', () {
      expect(WriteExercise.levenshteinDistance('a', 'b'), 1);
    });

    // ── single-operation cases ────────────────────────────────────────────────

    test('one insertion → 1', () {
      // "cat" → "cats" needs 1 insertion
      expect(WriteExercise.levenshteinDistance('cat', 'cats'), 1);
    });

    test('one deletion → 1', () {
      // "cats" → "cat" needs 1 deletion
      expect(WriteExercise.levenshteinDistance('cats', 'cat'), 1);
    });

    test('one substitution → 1', () {
      // "hond" → "bond" needs 1 substitution
      expect(WriteExercise.levenshteinDistance('hond', 'bond'), 1);
    });

    // ── case insensitivity ────────────────────────────────────────────────────

    test('same letters different case → 0', () {
      expect(WriteExercise.levenshteinDistance('Hond', 'hond'), 0);
    });

    test('fully uppercase vs lowercase → 0', () {
      expect(WriteExercise.levenshteinDistance('HOND', 'hond'), 0);
    });

    test('mixed case with substitution → counts only real diff', () {
      // "HOND" vs "bONd" → normalised to "hond" vs "bond" → 1 substitution
      expect(WriteExercise.levenshteinDistance('HOND', 'bONd'), 1);
    });

    // ── multi-operation cases ─────────────────────────────────────────────────

    test('transposition ("ab" → "ba") → 2', () {
      // Replace is used twice; Levenshtein does not treat transpose as 1 op
      expect(WriteExercise.levenshteinDistance('ab', 'ba'), 2);
    });

    test('classic "kitten" → "sitting" → 3', () {
      expect(WriteExercise.levenshteinDistance('kitten', 'sitting'), 3);
    });

    test('"sunday" → "saturday" → 3', () {
      expect(WriteExercise.levenshteinDistance('sunday', 'saturday'), 3);
    });

    test('completely different strings → max(len_a, len_b) in worst case', () {
      // "abc" vs "xyz" needs 3 substitutions
      expect(WriteExercise.levenshteinDistance('abc', 'xyz'), 3);
    });

    test('longer Dutch word with typo → 1', () {
      // "fiets" vs "fiets" with one wrong vowel: "fiats"
      expect(WriteExercise.levenshteinDistance('fiets', 'fiats'), 1);
    });

    test('prefix string → distance equals suffix length', () {
      // "vriend" vs "vriendin" → 2 insertions
      expect(WriteExercise.levenshteinDistance('vriend', 'vriendin'), 2);
    });

    test('symmetry: d(a,b) == d(b,a)', () {
      const a = 'werken';
      const b = 'wekken';
      expect(
        WriteExercise.levenshteinDistance(a, b),
        WriteExercise.levenshteinDistance(b, a),
      );
    });
  });
}
