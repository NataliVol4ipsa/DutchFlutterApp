import 'package:dutch_app/styles/base_styles.dart';
import 'package:flutter/material.dart';

class FormInputIcon extends StatelessWidget {
  final IconData icon;
  const FormInputIcon(
    this.icon, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      color: BaseStyles.getColorScheme(context).secondary,
    );
  }
}
