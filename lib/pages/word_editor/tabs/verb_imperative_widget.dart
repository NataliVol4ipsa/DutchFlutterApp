import 'package:dutch_app/pages/word_editor/inputs/verb/imperative_formal_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/imperative_informal_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class VerbImperativeTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController imperativeInformalController;
  final TextEditingController imperativeFormalController;

  const VerbImperativeTab({
    super.key,
    required this.wordTypeGetter,
    required this.imperativeInformalController,
    required this.imperativeFormalController,
  });

  static bool shouldShowTab(PartOfSpeech wordType) {
    return wordType == PartOfSpeech.verb;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.verb) ...[
          ImperativeInformalInput(
              textEditingController: imperativeInformalController),
          ImperativeFormalInput(
              textEditingController: imperativeFormalController),
        ]
      ],
    );
  }
}
