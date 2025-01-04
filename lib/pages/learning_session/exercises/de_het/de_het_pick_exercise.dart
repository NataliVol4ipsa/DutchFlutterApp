import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/de_het/de_het_pick_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

class DeHetPickExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.deHetPick;
  final Word word;

  late DeHetType correctAnswer;

  DeHetPickExercise(this.word) : super(requiredWords, type) {
    if (!isSupportedWord(word)) {
      throw Exception("Tried to create Exercise for unsupported word");
    }
    correctAnswer = word.deHetType;
  }

  static bool isSupportedWord(Word word) {
    return word.wordType == WordType.noun && word.deHetType != DeHetType.none;
  }

  bool isCorrectAnswer(DeHetType userAnswer) {
    return userAnswer == correctAnswer;
  }

  void processAnswer(DeHetType userAnswer) {
    if (isCorrectAnswer(userAnswer)) {
      answerSummary.totalCorrectAnswers++;
    } else {
      answerSummary.totalWrongAnswers++;
    }
  }

  @override
  Widget buildWidget({Key? key}) {
    return DeHetPickExerciseWidget(
      this,
      key: key,
    );
  }

  @override
  bool isAnswered() {
    return answerSummary.totalCorrectAnswers > 0 ||
        answerSummary.totalWrongAnswers > 0;
  }

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
          word: word,
          exerciseType: ExerciseType.deHetPick,
          totalCorrectAnswers: answerSummary.totalCorrectAnswers,
          totalWrongAnswers: answerSummary.totalWrongAnswers,
          correctAnswer: "${word.deHetType.name} ${word.dutchWord}")
    ];
  }
}
