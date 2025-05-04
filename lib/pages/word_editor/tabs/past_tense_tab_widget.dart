import 'package:dutch_app/domain/types/word_type.dart';
import 'package:flutter/material.dart';

class PastTenseTab extends StatelessWidget {
  final WordType Function() wordTypeGetter;

  const PastTenseTab({
    super.key,
    required this.wordTypeGetter,
  });

  static bool shouldShowTab(WordType wordType) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Past Tense"),
      ],
    );
  }
}
