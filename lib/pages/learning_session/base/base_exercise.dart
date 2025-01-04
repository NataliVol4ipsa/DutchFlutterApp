import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/exercise_answer_summary.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:flutter/material.dart';

abstract class BaseExercise {
  final int numOfRequiredWords;
  final ExerciseType exerciseType;
  late ExerciseAnswerSummary answerSummary = ExerciseAnswerSummary();

  BaseExercise(this.numOfRequiredWords, this.exerciseType);

  // Todo move all child implementations here?
  bool isAnswered();

  List<ExerciseSummaryDetailed> generateSummaries();

  Widget buildWidget({Key? key});
}
