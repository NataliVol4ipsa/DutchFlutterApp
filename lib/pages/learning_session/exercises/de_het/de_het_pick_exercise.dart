import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
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
    correctAnswer = word.nounDetails!.deHetType;
  }

  static bool isSupportedWord(Word word) {
    return word.partOfSpeech == PartOfSpeech.noun &&
        word.nounDetails != null &&
        word.nounDetails?.deHetType != DeHetType.none;
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
  Widget buildWidget(
      {Key? key,
      required Future<void> Function() onNextButtonPressed,
      required String nextButtonText}) {
    return DeHetPickExerciseWidget(
      this,
      key: key,
      onNextButtonPressed: onNextButtonPressed,
      nextButtonText: nextButtonText,
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
        correctAnswer: word.toDutchWordString(),
      )
    ];
  }
}
