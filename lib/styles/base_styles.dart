import 'package:flutter/material.dart';

abstract class BaseStyles {
  static ColorScheme getColorScheme(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}
