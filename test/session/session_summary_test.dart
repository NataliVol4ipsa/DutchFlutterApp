import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:flutter_test/flutter_test.dart';

// ── helpers ──────────────────────────────────────────────────────────────────

Word _word(int id) => Word(
  id,
  'word$id',
  ['translation'],
  PartOfSpeech.unspecified,
  nounDetails: null,
  verbDetails: null,
);

ExerciseSummaryDetailed _detail(
  int wordId, {
  ExerciseType exerciseType = ExerciseType.flipCard,
  int correct = 1,
  int wrong = 0,
}) => ExerciseSummaryDetailed(
  word: _word(wordId),
  exerciseType: exerciseType,
  totalCorrectAnswers: correct,
  totalWrongAnswers: wrong,
  correctAnswer: 'answer',
);

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('SessionSummary', () {
    test('zero mistakes → successRate=100, mistakeRate=0, totalMistakes=0', () {
      final summary = SessionSummary(
        totalWords: 5,
        totalExercises: 5,
        exerciseTypes: [ExerciseType.flipCard],
        detailedSummaries: List.generate(5, (i) => _detail(i)),
      );

      expect(summary.totalMistakes, 0);
      expect(summary.successRatePercent, 100.0);
      expect(summary.mistakeRatePercent, 0.0);
    });

    test('with mistakes: totalMistakes, rates computed correctly', () {
      // 5 exercises, 2 wrong answers in the detailed summaries
      // totalAttempts = 5 + 2 = 7
      // mistakeRate = 2/7 * 100
      final summaries = [
        _detail(0, wrong: 1),
        _detail(1, wrong: 1),
        _detail(2),
        _detail(3),
        _detail(4),
      ];

      final summary = SessionSummary(
        totalWords: 5,
        totalExercises: 5,
        exerciseTypes: [ExerciseType.flipCard],
        detailedSummaries: summaries,
      );

      expect(summary.totalMistakes, 2);
      final expectedMistakeRate = 2 * 100 / 7;
      expect(summary.mistakeRatePercent, closeTo(expectedMistakeRate, 0.001));
      expect(
        summary.successRatePercent,
        closeTo(100 - expectedMistakeRate, 0.001),
      );
    });

    test('totalExerciseTypes reflects exerciseTypes list length', () {
      final summary = SessionSummary(
        totalWords: 2,
        totalExercises: 2,
        exerciseTypes: [ExerciseType.flipCard],
        detailedSummaries: [_detail(0), _detail(1)],
      );
      expect(summary.totalExerciseTypes, 1);
    });
  });

  group('SingleExerciseTypeSummary', () {
    test('filters detailedSummaries by exerciseType', () {
      const typeA = ExerciseType.flipCard;

      final summaries = [
        _detail(0, exerciseType: typeA),
        _detail(1, exerciseType: typeA),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseType: typeA,
        detailedSummaries: summaries,
      );

      expect(single.totalWords, 2);
    });

    test('totalMistakes sums totalWrongAnswers for matching type only', () {
      const typeA = ExerciseType.flipCard;

      final summaries = [
        _detail(0, exerciseType: typeA, wrong: 2),
        _detail(1, exerciseType: typeA, wrong: 1),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseType: typeA,
        detailedSummaries: summaries,
      );

      expect(single.totalMistakes, 3);
    });

    test('successRatePercent and mistakeRatePercent are computed', () {
      const typeA = ExerciseType.flipCard;

      // 2 summaries, 0 wrong → 0/2 = 0% mistake rate
      final summaries = [
        _detail(0, exerciseType: typeA),
        _detail(1, exerciseType: typeA),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseType: typeA,
        detailedSummaries: summaries,
      );

      expect(single.mistakeRatePercent, 0.0);
      expect(single.successRatePercent, 100.0);
    });
  });
}
