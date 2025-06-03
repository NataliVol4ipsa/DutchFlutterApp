import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

class WriteExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.flipCard;
  final Word word;

  WriteExercise(this.word) : super(requiredWords, type);

  static bool isSupportedWord(Word word) {
    return word.partOfSpeech != PartOfSpeech.phrase;
  }

  @override
  Widget buildWidget(
      {Key? key,
      required Future<void> Function() onNextButtonPressed,
      required String nextButtonText}) {
    // TODO: implement buildWidget
    throw UnimplementedError();
  }

  @override
  bool isAnswered() {
    // TODO: implement isAnswered
    throw UnimplementedError();
  }

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
          word: word,
          exerciseType: ExerciseType.basicWrite,
          totalCorrectAnswers: answerSummary.totalCorrectAnswers,
          totalWrongAnswers: answerSummary.totalWrongAnswers,
          correctAnswer: word.dutchWord)
    ];
  }
}
