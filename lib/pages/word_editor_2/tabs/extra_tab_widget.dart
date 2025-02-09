import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/dutch_plural_form_input_widget.dart';
import 'package:flutter/material.dart';

class ExtraTab extends StatelessWidget {
  final WordType Function() wordTypeGetter;
  final TextEditingController dutchPluralFormController;

  const ExtraTab({
    super.key,
    required this.dutchPluralFormController,
    required this.wordTypeGetter,
  });

  static bool shouldShowTab(WordType wordType) {
    return wordType == WordType.noun;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (wordTypeGetter() == WordType.noun)
          DutchPluralFormInput(
            textEditingController: dutchPluralFormController,
          ),
      ],
    );
  }
}
