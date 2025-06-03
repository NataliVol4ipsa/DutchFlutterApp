import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/pages/word_editor/inputs/dutch_plural_form_input_widget.dart';
import 'package:flutter/material.dart';

class PluralsTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController dutchPluralFormController;

  const PluralsTab({
    super.key,
    required this.dutchPluralFormController,
    required this.wordTypeGetter,
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
      ],
    );
  }
}
