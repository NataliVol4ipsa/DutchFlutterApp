import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/pages/learning_session/summary/summary_total_cards_builder.dart';
import 'package:dutch_app/reusable_widgets/section_container_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
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
      padding: EdgeInsets.only(
          left: ContainerStyles.defaultPadding / 2,
          bottom: ContainerStyles.defaultPadding / 2,
          right: ContainerStyles.defaultPadding / 2),
      child: Column(
        children: [
          Padding(
            padding: ContainerStyles.containerPadding,
            child: const Text(
              "Totals:",
              style: TextStyles.sessionSummaryTitleTextStyle,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _totalsBuilder.buildWordsTotalCard(context),
              _totalsBuilder.buildExercisesTotalCard(context),
              _totalsBuilder.buildExerciseTypesTotalCard(context),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _totalsBuilder.buildMistakesTotalCard(context),
              _totalsBuilder.buildSuccessRateTotalCard(context),
              _totalsBuilder.buildMistakesRateTotalCard(context),
            ],
          ),
        ],
      ),
    );
  }
}
