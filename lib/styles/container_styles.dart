import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/cupertino.dart';

class ContainerStyles {
  static const double defaultPadding = 16;
  static const double smallPadding = 8;
  static const EdgeInsets containerPadding = EdgeInsets.all(defaultPadding);
  static const EdgeInsets smallContainerPadding = EdgeInsets.all(smallPadding);
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

  static Color section2Color(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHighest;
  static Color section2TextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color bottomNavBarColor(BuildContext context) => sectionColor(context);
  static Color bottomNavBarTextColor(BuildContext context) =>
      sectionTextColor(context);
  static Color bottomNavBarDisabledTextColor(BuildContext context) =>
      sectionTextColor(context).withAlpha(100);

  static BoxDecoration roundedEdgesDecoration(BuildContext context,
          {Color? color, bool useDefaultColor = true}) =>
      BoxDecoration(
        borderRadius: BorderStyles.bigBorderRadius,
        color: color ??
            (useDefaultColor ? ContainerStyles.sectionColor(context) : null),
      );
}
