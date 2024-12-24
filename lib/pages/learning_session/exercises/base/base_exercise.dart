import 'package:first_project/core/types/exercise_type.dart';
import 'package:first_project/pages/learning_session/exercises/exercise_answer_summary.dart';
import 'package:flutter/material.dart';

abstract class BaseExercise {
  final int numOfRequiredWords;
  final ExerciseType learningModeType;
  late ExerciseAnswerSummary answerSummary = ExerciseAnswerSummary();

  BaseExercise(this.numOfRequiredWords, this.learningModeType);

  // Todo move all child implementations here?
  bool isAnswered();

  Widget buildWidget({Key? key});
}
