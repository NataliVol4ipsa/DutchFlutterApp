import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

class FlipCardExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.flipCard;
  final Word word;

  late String inputWord;
  late String correctAnswer; //todo support multiple translations
  late String? hint;

  FlipCardExercise(this.word) : super(requiredWords, type) {
    if (!isSupportedWord(word)) {
      throw Exception("Tried to create Exercise for unsupported word");
    }
    inputWord = word.dutchWord;
    correctAnswer = word.englishWord;
    if (word.wordType != WordType.none) {
      hint = word.wordType.name;
    }
  }

  static bool isSupportedWord(Word word) {
    return true;
  }

  void processAnswer(bool userKnowsWord) {
    if (userKnowsWord) {
      answerSummary.totalCorrectAnswers++;
    } else {
      answerSummary.totalWrongAnswers++;
    }
  }

  @override
  Widget buildWidget({Key? key}) {
    return FlipCardExerciseWidget(
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
          exerciseType: ExerciseType.flipCard,
          totalCorrectAnswers: answerSummary.totalCorrectAnswers,
          totalWrongAnswers: answerSummary.totalWrongAnswers,
          correctAnswer: "${word.dutchWord} - ${word.englishWord}")
    ];
  }
}
