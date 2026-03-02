import 'package:dutch_app/domain/models/word_exercises_to_unlock.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/reusable_widgets/section_container_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class UnlockedExercisesCard extends StatelessWidget {
  final List<WordExercisesToUnlock> newUnlocks;

  const UnlockedExercisesCard({super.key, required this.newUnlocks});

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      padding: ContainerStyles.containerPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.lock_open, color: Colors.amber, size: 28),
              const SizedBox(width: 8),
              Text(
                'New exercises unlocked!',
                style: TextStyles.sessionSummaryTitleTextStyle,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: ContainerStyles.containerPadding,
            decoration: BoxDecoration(
              borderRadius: BorderStyles.bigBorderRadius,
              color: ContainerStyles.section2Color(context),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: newUnlocks
                  .map((r) => _buildWordRow(context, r))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordRow(BuildContext context, WordExercisesToUnlock result) {
    final types = result.newlyUnlocked.map((t) => t.label).join(', ');
    return Padding(
      padding: ContainerStyles.smallContainerPadding,
      child: RichText(
        text: TextSpan(
          style: TextStyles.sessionSummaryCardtitleTextStyle(context),
          children: [
            TextSpan(
              text: result.word.toDutchWordString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const TextSpan(text: '  \u2192  '),
            TextSpan(
              text: types,
              style: const TextStyle(color: Colors.amber),
            ),
          ],
        ),
      ),
    );
  }
}
