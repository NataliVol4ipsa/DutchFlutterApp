import 'package:dutch_app/core/types/word_type.dart';
import 'package:flutter/material.dart';

class HeaderTab {
  final String name;
  final Widget Function(WordType) widgetBuilder;
  bool isSelected;

  HeaderTab(
      {required this.name,
      required this.widgetBuilder,
      this.isSelected = false});
}
