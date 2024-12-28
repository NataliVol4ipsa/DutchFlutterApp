import 'package:first_project/pages/learning_session/exercises/base/base_exercise_layout_widget.dart';
import 'package:first_project/pages/learning_session/summary/session_summary.dart';
import 'package:first_project/pages/learning_session/summary/summary_total_cards_builder.dart';
import 'package:first_project/styles/button_styles.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/text_styles.dart';
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
  final SummaryTotalCardsBuilder _totalsBuilder;

  SessionSummaryWidget({
    super.key,
    required this.summary,
  }) : _totalsBuilder = SummaryTotalCardsBuilder(summary: summary);

  Widget _buildTotalsSection(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var totalsBackgroundColor = colorScheme.surfaceVariant;

    return Container(
      padding: ContainerStyles.containerPadding,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: totalsBackgroundColor,
      ),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text(
            "Totals:",
            style: TextStyles.sessionSummaryTitleTextStyle,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _totalsBuilder.buildWordsTotalCard(),
              _totalsBuilder.buildExercisesTotalCard(),
              _totalsBuilder.buildExerciseTypesTotalCard(),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _totalsBuilder.buildMistakesTotalCard(),
              _totalsBuilder.buildSuccessRateTotalCard(),
              _totalsBuilder.buildMistakesRateTotalCard(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseExerciseLayout(
      contentBuilder: (context) {
        return Column(
          children: [
            _buildTotalsSection(context),
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
