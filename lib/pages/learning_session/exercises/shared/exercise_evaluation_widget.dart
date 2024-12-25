import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class ExerciseEvaluation extends StatelessWidget {
  const ExerciseEvaluation({
    super.key,
    required this.isExerciseAnswered,
    required this.isCorrectAnswer,
  });

  final bool isExerciseAnswered;
  final bool? isCorrectAnswer;

  @override
  Widget build(BuildContext context) {
    if (!isExerciseAnswered) {
      return const Text(' ', style: TextStyles.exerciseEvaluationTextStyle);
    }

    if (isCorrectAnswer == true) {
      return Text("Correct!", style: TextStyles.successEvaluationStyle);
    }

    return Text("Wrong!", style: TextStyles.failureEvaluationStyle);
  }
}
