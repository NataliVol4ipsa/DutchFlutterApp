import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ExerciseEvaluation extends StatelessWidget {
  const ExerciseEvaluation({
    super.key,
    required this.isExerciseAnswered,
    required this.isCorrectAnswer,
    this.successTextOverride,
    this.failureTextOverride,
  });

  final bool isExerciseAnswered;
  final bool? isCorrectAnswer;
  final String? successTextOverride;
  final String? failureTextOverride;

  @override
  Widget build(BuildContext context) {
    if (!isExerciseAnswered) {
      return const Text(' ', style: TextStyles.exerciseEvaluationTextStyle);
    }

    if (isCorrectAnswer == true) {
      return Text(successTextOverride ?? "Correct!",
          style: TextStyles.successEvaluationStyle,
          textAlign: TextAlign.center);
    }

    return Text(
      failureTextOverride ?? "Wrong!",
      style: TextStyles.failureEvaluationStyle,
      textAlign: TextAlign.center,
    );
  }
}
