import 'package:first_project/core/types/exercise_type.dart';
import 'package:flutter/material.dart';

abstract class BaseExercise {
  final int numOfRequiredWords;
  final ExerciseType learningModeType;

  BaseExercise(this.numOfRequiredWords, this.learningModeType);

  bool isAnswered();

  Widget buildWidget({Key? key});
}
