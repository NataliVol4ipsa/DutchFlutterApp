import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/cupertino.dart';

class ContainerStyles {
  static const double roundedEdgeRadius = 20;
  static const double defaultPadding = 16;
  static const EdgeInsets containerPadding = EdgeInsets.all(defaultPadding);
  static const EdgeInsets smallContainerPadding =
      EdgeInsets.all(defaultPadding / 2);
  static const EdgeInsets betweenCardsPadding =
      EdgeInsets.symmetric(vertical: 10);

  static Color backgroundColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surface;
  static Color backgroundTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color selectedSecondaryColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).secondaryContainer;
  static Color selectedSecondaryTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSecondaryContainer;

  static Color selectedPrimaryColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).primaryContainer;
  static Color selectedPrimaryTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onPrimaryContainer;

  static Color defaultColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surface;

  static Color sectionColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHigh;
  static Color sectionTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color sectionColor2(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHighest;
  static Color sectionColor2Text(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static BoxDecoration roundedEdgesDecoration(BuildContext context,
          {Color? color, bool useDefaultColor = true}) =>
      BoxDecoration(
        borderRadius: BorderRadius.circular(roundedEdgeRadius),
        color: color ??
            (useDefaultColor ? ContainerStyles.sectionColor(context) : null),
      );
}
