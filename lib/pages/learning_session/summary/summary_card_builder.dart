import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SummaryCardBuilder {
  static Widget buildTotalCard(BuildContext context, String title, String stat,
      {TextStyle? titleStyleOverride,
      TextStyle? statStyleOverride,
      Color? statColorOverride}) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(stat,
                style: statStyleOverride ??
                    TextStyles.sessionSummaryNeutralStatStyle.copyWith(
                        color: statColorOverride ??
                            TextStyles.sessionSummaryNeutralStatStyle.color)),
          ),
          Text(title,
              maxLines: 2,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: titleStyleOverride ??
                  TextStyles.sessionSummaryCardtitleTextStyle(context)),
        ],
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
