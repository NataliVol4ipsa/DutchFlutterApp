import 'dart:math';

import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_exercise_widget.dart';
import 'package:dutch_app/pages/learning_session/exercises/many_to_many/many_to_many_option.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/widgets.dart';

class ManyToManyExercise extends BaseExercise {
  static const int requiredWords = 5;
  static const ExerciseType type = ExerciseType.manyToMany;

  final List<Word> words;

  late List<ManyToManyOption> leftOptions = [];
  late List<ManyToManyOption> rightOptions = [];

  List<int> numOfMistakes = List.filled(requiredWords, 0);

  int numOfCompletedPairs = 0;

  ManyToManyExercise(this.words) : super(requiredWords, type) {
    for (int i = 0; i < words.length; i++) {
      leftOptions
          .add(ManyToManyOption(id: i, word: words[i].toDutchWordString()));
      rightOptions.add(ManyToManyOption(id: i, word: words[i].englishWord));
    }

    leftOptions.shuffle(Random());
    rightOptions.shuffle(Random());
  }

  static bool isSupportedWord(Word word) {
    return word.wordType != WordType.phrase;
  }

  bool processAnswer(ManyToManyOption left, ManyToManyOption right) {
    if (left.id == right.id) {
      numOfCompletedPairs++;
      answerSummary.totalCorrectAnswers++;
      return true;
    }

    numOfMistakes[left.id]++;

    return false;
  }

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    List<ExerciseSummaryDetailed> result = [];

    for (int i = 0; i < words.length; i++) {
      var word = words[i];
      result.add(ExerciseSummaryDetailed(
          word: word,
          exerciseType: ExerciseType.manyToMany,
          totalCorrectAnswers: 1,
          totalWrongAnswers: numOfMistakes[i],
          correctAnswer: "${word.toDutchWordString()} - ${word.englishWord}"));
    }

    return result;
  }

  @override
  bool isAnswered() {
    return numOfCompletedPairs == words.length;
  }

  @override
  Widget buildWidget(
      {Key? key,
      required Future<void> Function() onNextButtonPressed,
      required String nextButtonText}) {
    return ManyToManyExerciseWidget(
        exercise: this,
        key: key,
        onNextButtonPressed: onNextButtonPressed,
        nextButtonText: nextButtonText);
  }
}
