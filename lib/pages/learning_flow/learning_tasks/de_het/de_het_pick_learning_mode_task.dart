import 'package:first_project/pages/learning_flow/learning_tasks/base_learning_mode_task.dart';
import 'package:first_project/pages/learning_flow/learning_tasks/task_answer_summary.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/learning_mode_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:first_project/pages/learning_flow/learning_tasks/de_het/de_het_pick_learning_task_widget.dart';
import 'package:flutter/material.dart';

class DeHetPickLearningModeTask extends BaseLearningModeTask {
  static const int requiredWords = 1;
  static const LearningModeType type = LearningModeType.deHetPick;
  final Word word;

  late String dutchWord;
  late DeHetType correctAnswer;
  late TaskAnswerSummary answerSummary = TaskAnswerSummary();

  DeHetPickLearningModeTask(this.word) : super(requiredWords, type) {
    if (!isSupportedWord(word)) {
      throw Exception("Tried to create Task for unsupported word");
    }
    dutchWord = word.dutchWord;
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

  bool showAgain() {
    return answerSummary.totalCorrectAnswers == 0;
  }

  @override
  Widget buildWidget({Key? key}) {
    return DeHetPickLearningTaskWidget(
      this,
      dutchWord,
      key: key,
    );
  }

  @override
  bool isAnswered() {
    return answerSummary.totalCorrectAnswers > 0 ||
        answerSummary.totalWrongAnswers > 0;
  }
}
