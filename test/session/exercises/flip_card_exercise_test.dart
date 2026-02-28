import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/anki_flip_card_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise.dart';
import 'package:flutter_test/flutter_test.dart';

// ── helper ────────────────────────────────────────────────────────────────────

Word _word() => Word(
  1,
  'hond',
  ['dog'],
  PartOfSpeech.noun,
  nounDetails: WordNounDetails(),
  verbDetails: null,
);

// ── tests ─────────────────────────────────────────────────────────────────────

void main() {
  group('FlipCardExercise', () {
    test('processAnswer(true) increments correctAnswers', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(true);
      expect(exercise.answerSummary.totalCorrectAnswers, 1);
      expect(exercise.answerSummary.totalWrongAnswers, 0);
    });

    test('processAnswer(false) increments wrongAnswers', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(false);
      expect(exercise.answerSummary.totalWrongAnswers, 1);
      expect(exercise.answerSummary.totalCorrectAnswers, 0);
    });

    test('isAnswered() returns false before any answer', () {
      final exercise = FlipCardExercise(_word());
      expect(exercise.isAnswered(), isFalse);
    });

    test('isAnswered() returns true after correct answer', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(true);
      expect(exercise.isAnswered(), isTrue);
    });

    test('isAnswered() returns true after wrong answer', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(false);
      expect(exercise.isAnswered(), isTrue);
    });

    test('generateSummaries() returns one ExerciseSummaryDetailed', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(true);
      final summaries = exercise.generateSummaries();
      expect(summaries.length, 1);
      expect(summaries.first.exerciseType, ExerciseType.flipCard);
      expect(summaries.first.totalCorrectAnswers, 1);
      expect(summaries.first.totalWrongAnswers, 0);
    });

    test('generateSummaries() reflects wrong answers', () {
      final exercise = FlipCardExercise(_word());
      exercise.processAnswer(false);
      final summaries = exercise.generateSummaries();
      expect(summaries.first.totalWrongAnswers, 1);
      expect(summaries.first.totalCorrectAnswers, 0);
    });
  });

  group('AnkiFlipCardExercise', () {
    test('isAnswered() returns false before any grade', () {
      final exercise = AnkiFlipCardExercise(_word());
      expect(exercise.isAnswered(), isFalse);
    });

    test('processAnswer(AnkiGrade.again) increments wrongAnswers', () {
      final exercise = AnkiFlipCardExercise(_word());
      exercise.processAnswer(AnkiGrade.again);
      expect(exercise.answerSummary.totalWrongAnswers, 1);
      expect(exercise.answerSummary.totalCorrectAnswers, 0);
      expect(exercise.isAnswered(), isTrue);
    });

    test('processAnswer(AnkiGrade.hard) increments wrongAnswers', () {
      final exercise = AnkiFlipCardExercise(_word());
      exercise.processAnswer(AnkiGrade.hard);
      expect(exercise.answerSummary.totalWrongAnswers, 1);
    });

    test('processAnswer(AnkiGrade.good) increments correctAnswers', () {
      final exercise = AnkiFlipCardExercise(_word());
      exercise.processAnswer(AnkiGrade.good);
      expect(exercise.answerSummary.totalCorrectAnswers, 1);
      expect(exercise.answerSummary.totalWrongAnswers, 0);
      expect(exercise.isAnswered(), isTrue);
    });

    test('processAnswer(AnkiGrade.easy) increments correctAnswers', () {
      final exercise = AnkiFlipCardExercise(_word());
      exercise.processAnswer(AnkiGrade.easy);
      expect(exercise.answerSummary.totalCorrectAnswers, 1);
    });

    test('generateSummaries() carries chosen grade', () {
      final exercise = AnkiFlipCardExercise(_word());
      exercise.processAnswer(AnkiGrade.good);
      final summaries = exercise.generateSummaries();
      expect(summaries.length, 1);
      expect(summaries.first.ankiGrade, AnkiGrade.good);
      expect(summaries.first.exerciseType, ExerciseType.flipCard);
      expect(summaries.first.totalCorrectAnswers, 1);
    });
  });
}
