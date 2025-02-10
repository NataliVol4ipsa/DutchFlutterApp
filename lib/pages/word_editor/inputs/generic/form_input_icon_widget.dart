import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class FormInputIcon extends StatelessWidget {
  final IconData icon;
  final Color? overrideColor;
  const FormInputIcon(this.icon, {super.key, this.overrideColor});

  @override
  Widget build(BuildContext context) {
    var color = overrideColor ??
        BaseStyles.getColorScheme(context).onSurface.withAlpha(200);
    return Icon(
      icon,
      color: color,
    );
  }
}
