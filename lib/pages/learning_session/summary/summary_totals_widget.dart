import 'package:first_project/pages/learning_session/summary/session_summary.dart';
import 'package:first_project/pages/learning_session/summary/summary_total_cards_builder.dart';
import 'package:first_project/reusable_widgets/section_container_widget.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SummaryTotals extends StatelessWidget {
  final SessionSummary summary;
  final SummaryTotalCardsBuilder _totalsBuilder;

  SummaryTotals({
    super.key,
    required this.summary,
  }) : _totalsBuilder = SummaryTotalCardsBuilder(summary: summary);

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
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
}
