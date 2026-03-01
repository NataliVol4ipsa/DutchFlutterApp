import 'dart:math';

import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/exercises/write/write_exercise_widget.dart';
import 'package:flutter/material.dart';

class WriteExercise extends BaseExercise {
  static const int requiredWords = 1;
  static const ExerciseType type = ExerciseType.basicWrite;
  final Word word;

  late final String englishPrompt;

  bool _isAnswered = false;

  WriteExercise(this.word) : super(requiredWords, type) {
    englishPrompt = SemicolonWordsConverter.toSingleString(word.englishWords);
  }

  static bool isSupportedWord(
    Word word, {
    bool includePhrasesInWriting = false,
  }) {
    if (word.partOfSpeech == PartOfSpeech.phrase) {
      return includePhrasesInWriting;
    }
    return true;
  }

  static String normaliseInput(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  static int levenshteinDistance(String a, String b) {
    final al = a.toLowerCase();
    final bl = b.toLowerCase();
    final m = al.length;
    final n = bl.length;
    final dp = List.generate(m + 1, (i) => List.filled(n + 1, 0));
    for (var i = 0; i <= m; i++) {
      dp[i][0] = i;
    }
    for (var j = 0; j <= n; j++) {
      dp[0][j] = j;
    }
    for (var i = 1; i <= m; i++) {
      for (var j = 1; j <= n; j++) {
        if (al[i - 1] == bl[j - 1]) {
          dp[i][j] = dp[i - 1][j - 1];
        } else {
          dp[i][j] =
              1 + [dp[i - 1][j], dp[i][j - 1], dp[i - 1][j - 1]].reduce(min);
        }
      }
    }
    return dp[m][n];
  }

  void processAnswer(bool isCorrect) {
    _isAnswered = true;
    if (isCorrect) {
      answerSummary.totalCorrectAnswers++;
    } else {
      answerSummary.totalWrongAnswers++;
    }
  }

  @override
  bool isAnswered() => _isAnswered;

  @override
  Widget buildWidget({
    Key? key,
    required Future<void> Function() onNextButtonPressed,
    required String nextButtonText,
  }) {
    return WriteExerciseWidget(
      this,
      key: key,
      onNextButtonPressed: onNextButtonPressed,
      nextButtonText: nextButtonText,
    );
  }

  @override
  List<ExerciseSummaryDetailed> generateSummaries() {
    return [
      ExerciseSummaryDetailed(
        word: word,
        exerciseType: ExerciseType.basicWrite,
        totalCorrectAnswers: answerSummary.totalCorrectAnswers,
        totalWrongAnswers: answerSummary.totalWrongAnswers,
        correctAnswer: word.dutchWord,
      ),
    ];
  }
}
