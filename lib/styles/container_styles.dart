import 'package:dutch_app/styles/base_styles.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

class ContainerStyles {
  static const double defaultPaddingAmount = 16;
  static const double smallPaddingAmount = 8;
  static const double smallPaddingAmount2 = 12;
  static const double betweenCardsPaddingAmount = 10;
  static const EdgeInsets containerPadding =
      EdgeInsets.all(defaultPaddingAmount);
  static const EdgeInsets smallContainerPadding =
      EdgeInsets.all(smallPaddingAmount);
  static const EdgeInsets smallContainerPadding2 =
      EdgeInsets.all(smallPaddingAmount2);
  static const EdgeInsets betweenCardsPadding =
      EdgeInsets.symmetric(vertical: betweenCardsPaddingAmount);

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

  static Color secondaryHeaderColor(BuildContext context) =>
      _themedAdjustedColorByPercent(
          context, BaseStyles.getColorScheme(context).secondaryContainer,
          darkenLightPercent: 10, darkenDarkPercent: 20);
  static Color secondaryHeaderTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSecondaryContainer;

  static Color sectionColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHigh;
  static Color sectionTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color section2Color(BuildContext context) =>
      BaseStyles.getColorScheme(context).surfaceContainerHighest;
  static Color section2TextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color section3Color(
          BuildContext context) =>
      _themedAdjustedColorByPercent(
          context, BaseStyles.getColorScheme(context).surfaceContainerHighest,
          darkenLightPercent: 10, lightenDarkPercent: 20);
  static Color section3TextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color chipColor(BuildContext context) => _themedAdjustedColorByPercent(
      context, BaseStyles.getColorScheme(context).surfaceContainerHighest,
      darkenLightPercent: 5, lightenDarkPercent: 10);
  static Color chipTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSecondaryContainer;

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

  static Color wordListCollectionColor(BuildContext context) => Color.lerp(
      BaseStyles.getColorScheme(context).surfaceContainerHigh,
      BaseStyles.getColorScheme(context).tertiary,
      0.1)!;
  static Color wordListCollectionTextColor(BuildContext context) =>
      BaseStyles.getColorScheme(context).onSurface;

  static Color _themedAdjustedColor(
    BuildContext context, {
    required Color lightModeColor,
    required Color darkModeColor,
  }) {
    return Theme.of(context).brightness == Brightness.dark
        ? darkModeColor
        : lightModeColor;
  }

  static Color _themedAdjustedColorByPercent(BuildContext context, Color color,
      {int darkenDarkPercent = 0,
      int darkenLightPercent = 0,
      int lightenDarkPercent = 0,
      int lightenLightPercent = 0}) {
    return _themedAdjustedColor(
      context,
      lightModeColor:
          color.darken(darkenLightPercent).lighten(lightenLightPercent),
      darkModeColor:
          color.brighten(lightenDarkPercent).darken(darkenDarkPercent),
    );
  }
}
