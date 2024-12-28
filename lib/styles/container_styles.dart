import 'package:first_project/styles/base_styles.dart';
import 'package:flutter/cupertino.dart';

class ContainerStyles {
  static const double defaultPadding = 16;
  static const EdgeInsets containerPadding = EdgeInsets.all(defaultPadding);
  static const EdgeInsets smallContainerPadding =
      EdgeInsets.all(defaultPadding / 2);
  static const EdgeInsets betweenCardsPadding =
      EdgeInsets.symmetric(vertical: 10);

  static Color defaultColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).background;

  static Color sectionColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceVariant;

  static Color sectionColor2(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceVariant.withOpacity(0.5);
}
