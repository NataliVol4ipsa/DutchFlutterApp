import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter/material.dart';

class PastTenseTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;

  const PastTenseTab({
    super.key,
    required this.wordTypeGetter,
  });

  static bool shouldShowTab(PartOfSpeech wordType) {
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
