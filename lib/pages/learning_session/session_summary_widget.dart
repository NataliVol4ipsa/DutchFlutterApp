import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/session_manager.dart';
import 'package:first_project/styles/button_styles.dart';
import 'package:flutter/material.dart';

class SessionSummaryWidget extends StatelessWidget {
  const SessionSummaryWidget({
    super.key,
    required this.summary,
  });

  final SessionSummary summary;

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
      contentBuilder: (context) {
        return Column(
          children: [
            Text('Total exercises: ${summary.totalExercises}'),
            Text(
                'Correct answers: ${summary.correctExercises} (${summary.correctPercent.toStringAsFixed(2)}%)'),
          ],
        );
      },
      footerBuilder: (context) {
        return ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          style: ButtonStyles.primaryButtonStyle,
          child: const Text(
            "Back to menu",
            style: TextStyle(fontSize: 20),
          ),
        );
      },
    );
  }
}
