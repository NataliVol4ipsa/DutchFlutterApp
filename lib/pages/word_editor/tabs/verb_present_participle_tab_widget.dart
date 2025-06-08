import 'package:dutch_app/pages/word_editor/inputs/verb/present_participle_inflected_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_participle_uninflected_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class VerbPresentParticipleTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController presentParticipleUninflectedController;
  final TextEditingController presentParticipleInflectedController;

  const VerbPresentParticipleTab({
    super.key,
    required this.wordTypeGetter,
    required this.presentParticipleUninflectedController,
    required this.presentParticipleInflectedController,
  });

  static bool shouldShowTab(PartOfSpeech wordType) {
    return wordType == PartOfSpeech.verb;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.verb) ...[
          PresentParticipleUninflectedInput(
              textEditingController: presentParticipleUninflectedController),
          PresentParticipleInflectedInput(
              textEditingController: presentParticipleInflectedController),
        ]
      ],
    );
  }
}
