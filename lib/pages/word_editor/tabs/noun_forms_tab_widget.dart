import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/word_editor/inputs/dutch_diminutive_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/dutch_plural_form_input_widget.dart';
import 'package:flutter/material.dart';

class NounFormsTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController dutchPluralFormController;
  final TextEditingController diminutiveController;

  const NounFormsTab({
    super.key,
    required this.dutchPluralFormController,
    required this.wordTypeGetter,
    required this.diminutiveController,
  });

  static bool shouldShowTab(PartOfSpeech wordType) {
    return wordType == PartOfSpeech.noun;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.noun)
          DutchPluralFormInput(
            textEditingController: dutchPluralFormController,
          ),
        DutchDiminutiveFormInput(
          textEditingController: diminutiveController,
        ),
      ],
    );
  }
}
