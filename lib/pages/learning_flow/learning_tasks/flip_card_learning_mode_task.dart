import 'package:first_project/pages/learning_flow/learning_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';
import 'package:flutter/material.dart';

class FlipCardLearningModeTask extends BaseLearningModeTask {
  static const int requiredWords = 1;
  static const LearningModeType type = LearningModeType.flipCard;
  final Word word;

  FlipCardLearningModeTask(this.word) : super(requiredWords, type);

  static bool isSupportedWord(Word word) {
    return true;
  }

  @override
  Widget buildWidget({Key? key}) {
    // TODO: implement buildWidget
    throw UnimplementedError();
  }

  @override
  bool isAnswered() {
    // TODO: implement isAnswered
    throw UnimplementedError();
  }
}
