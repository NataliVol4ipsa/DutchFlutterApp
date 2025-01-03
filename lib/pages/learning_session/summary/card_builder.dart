import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class CardBuilder {
  static Widget buildTotalCard(String title, String stat,
      {TextStyle? titleStyleOverride,
      TextStyle? statStyleOverride,
      Color? statColorOverride}) {
    return Expanded(
      child: Padding(
        padding: ContainerStyles.smallContainerPadding,
        child: Column(
          children: [
            Text(stat,
                style: statStyleOverride ??
                    TextStyles.sessionSummaryNeutralStatStyle.copyWith(
                        color: statColorOverride ??
                            TextStyles.sessionSummaryNeutralStatStyle.color)),
            Text(title,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titleStyleOverride ??
                    TextStyles.sessionSummaryCardtitleTextStyle),
          ],
        ),
      ),
    );
  }

  static Color mistakesColor(int mistakes) {
    if (mistakes == 0) {
      return TextStyles.successTextColor;
    }
    return TextStyles.failureTextColor;
  }

  static Color mistakeRateColor(double mistakesRate) {
    if (mistakesRate == 0) {
      return TextStyles.successTextColor;
    }
    return TextStyles.failureTextColor;
  }

  static String percentToString(double percent) {
    return "${percent.toStringAsFixed(0)}%";
  }
}
