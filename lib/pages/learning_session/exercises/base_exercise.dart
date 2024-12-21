import 'package:first_project/core/types/learning_mode_type.dart';
import 'package:flutter/material.dart';

abstract class BaseExercise {
  final int numOfRequiredWords;
  final LearningModeType learningModeType;

  BaseExercise(this.numOfRequiredWords, this.learningModeType);

  bool isAnswered();

  Widget buildWidget({Key? key});
}
