import 'package:dutch_app/domain/models/word.dart';
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

    // ── flipcard merging ────────────────────────────────────────────────────
    test('both flipCard and flipCardReverse are merged into one group', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.flipCardReverse),
      ];

      final session = SessionSummary(
        totalWords: 2,
        totalExercises: 2,
        exerciseTypes: [ExerciseType.flipCard, ExerciseType.flipCardReverse],
        detailedSummaries: summaries,
      );

      // Even though there are 2 exercise types, they're merged into 1 group
      expect(session.summariesPerExercise.length, 1);
    });

    test('merged flipcard group contains summaries from both directions', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.flipCardReverse),
      ];

      final session = SessionSummary(
        totalWords: 2,
        totalExercises: 2,
        exerciseTypes: [ExerciseType.flipCard, ExerciseType.flipCardReverse],
        detailedSummaries: summaries,
      );

      final group = session.summariesPerExercise.first;
      expect(group.totalWords, 2);
    });

    test('flipcard group and writing are two separate summary groups', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.flipCardReverse),
        _detail(2, exerciseType: ExerciseType.basicWrite),
      ];

      final session = SessionSummary(
        totalWords: 3,
        totalExercises: 3,
        exerciseTypes: [
          ExerciseType.flipCard,
          ExerciseType.flipCardReverse,
          ExerciseType.basicWrite,
        ],
        detailedSummaries: summaries,
      );

      expect(session.summariesPerExercise.length, 2);
    });

    test('session with only flipCardReverse still produces one group', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCardReverse),
      ];

      final session = SessionSummary(
        totalWords: 1,
        totalExercises: 1,
        exerciseTypes: [ExerciseType.flipCardReverse],
        detailedSummaries: summaries,
      );

      expect(session.summariesPerExercise.length, 1);
      expect(session.summariesPerExercise.first.totalWords, 1);
    });
  });

  group('SingleExerciseTypeSummary', () {
    test('filters detailedSummaries by exerciseTypes set', () {
      const typeA = ExerciseType.flipCard;

      final summaries = [
        _detail(0, exerciseType: typeA),
        _detail(1, exerciseType: typeA),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseTypes: {typeA},
        detailedSummaries: summaries,
      );

      expect(single.totalWords, 2);
    });

    test('filters out unrelated exercise types', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.basicWrite),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.flipCard},
        detailedSummaries: summaries,
      );

      expect(single.totalWords, 1);
    });

    test('multi-type set includes summaries from all included types', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.flipCardReverse),
        _detail(2, exerciseType: ExerciseType.basicWrite),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.flipCard, ExerciseType.flipCardReverse},
        detailedSummaries: summaries,
      );

      // Only flipCard and flipCardReverse; basicWrite excluded
      expect(single.totalWords, 2);
    });

    test('totalMistakes sums totalWrongAnswers for matching types only', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard, wrong: 2),
        _detail(1, exerciseType: ExerciseType.flipCardReverse, wrong: 1),
        _detail(2, exerciseType: ExerciseType.basicWrite, wrong: 5),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.flipCard, ExerciseType.flipCardReverse},
        detailedSummaries: summaries,
      );

      expect(single.totalMistakes, 3); // 2+1 from flipcard types only
    });

    test('successRatePercent and mistakeRatePercent computed correctly', () {
      final summaries = [
        _detail(0, exerciseType: ExerciseType.flipCard),
        _detail(1, exerciseType: ExerciseType.flipCard),
      ];

      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.flipCard},
        detailedSummaries: summaries,
      );

      expect(single.mistakeRatePercent, 0.0);
      expect(single.successRatePercent, 100.0);
    });

    // ── displayLabel ────────────────────────────────────────────────────────
    test('displayLabel for single type is that type\'s label', () {
      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.basicWrite},
        detailedSummaries: [],
      );
      expect(single.displayLabel, ExerciseType.basicWrite.label);
    });

    test('displayLabel for merged flipcard group is FlipCard Translation', () {
      final single = SingleExerciseTypeSummary(
        exerciseTypes: {ExerciseType.flipCard, ExerciseType.flipCardReverse},
        detailedSummaries: [],
      );
      expect(single.displayLabel, 'FlipCard Translation');
    });
  });
}
