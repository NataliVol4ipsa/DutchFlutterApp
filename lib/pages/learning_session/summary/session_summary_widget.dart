import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/summary/session_summary.dart';
import 'package:first_project/pages/learning_session/summary/summary_totals_widget.dart';
import 'package:first_project/styles/button_styles.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

// todo animate main stats numbers slowly appear on screen.
// rushing through all numbers from 1 to N.
// success rate is last one, and it fades from transparent opacity to full opacity
// then a nice super sticker slaps under 45 degree at top right corner of screen
// if success rate is 100%
// this sticker contains different phrases, appraising user.
// Wow, cool, super, amazing, bravo, your dog is proud of you, etc.
// if user taps again - speed up animations.
// test on slower devices
class SessionSummaryWidget extends StatelessWidget {
  final SessionSummary summary;

  const SessionSummaryWidget({
    super.key,
    required this.summary,
  });

  @override
  Widget build(BuildContext context) {
    final List<Widget> contentSections = [
      SummaryTotals(summary: summary),
    ];

    return BaseExerciseLayout(
      contentBuilder: (context) {
        return ListView.builder(
          itemCount: contentSections.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: ContainerStyles.betweenCardsPadding,
              child: contentSections[index],
            );
          },
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
