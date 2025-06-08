import 'package:dutch_app/pages/word_editor/inputs/verb/auxiliary_verb_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/completed_participle_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/infinitive_input_widget.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class VerbFormsTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController infinitiveController;
  final TextEditingController completedParticipleController;
  final TextEditingController auxiliaryVerbController;

  const VerbFormsTab({
    super.key,
    required this.wordTypeGetter,
    required this.infinitiveController,
    required this.completedParticipleController,
    required this.auxiliaryVerbController,
  });

  static bool shouldShowTab(PartOfSpeech wordType) {
    return wordType == PartOfSpeech.verb;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.verb) ...[
          InfinitiveInput(textEditingController: infinitiveController),
          CompletedParticipleInput(
              textEditingController: completedParticipleController),
          AuxiliaryVerbInput(textEditingController: auxiliaryVerbController),
        ]
      ],
    );
  }
}
