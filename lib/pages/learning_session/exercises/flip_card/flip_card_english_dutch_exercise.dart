import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/flip_card/flip_card_english_dutch_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

class FlipCardEnglishDutchExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.flipCardReverse;
  final Word word;
  late String inputWord;
  late String correctAnswer;
  late String? hint;

  FlipCardEnglishDutchExercise(this.word) : super(requiredWords, type) {
    inputWord = SemicolonWordsConverter.toSingleString(word.englishWords);
    correctAnswer = word.toDutchWordString();
    hint = word.partOfSpeech != PartOfSpeech.unspecified
        ? word.partOfSpeech.name
        : null;
  }

  static bool isSupportedWord(Word word) => true;

  void processAnswer(bool userKnowsWord) {
    if (userKnowsWord) {
      answerSummary.totalCorrectAnswers++;
    } else {
      answerSummary.totalWrongAnswers++;
    }
  }

  @override
  Widget buildWidget({
    Key? key,
    required Future<void> Function() onNextButtonPressed,
    required String nextButtonText,
  }) {
    return FlipCardEnglishDutchExerciseWidget(
      this,
      key: key,
      onNextButtonPressed: onNextButtonPressed,
      nextButtonText: nextButtonText,
    );
  }

  @override
  bool isAnswered() =>
      answerSummary.totalCorrectAnswers > 0 ||
      answerSummary.totalWrongAnswers > 0;

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
        word: word,
        exerciseType: ExerciseType.flipCardReverse,
        totalCorrectAnswers: answerSummary.totalCorrectAnswers,
        totalWrongAnswers: answerSummary.totalWrongAnswers,
        correctAnswer: '${inputWord} → ${correctAnswer}',
      ),
    ];
  }
}
