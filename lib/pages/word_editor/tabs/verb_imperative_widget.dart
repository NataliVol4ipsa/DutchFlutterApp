import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_row_data.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_table.dart';
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
    if (wordTypeGetter() != PartOfSpeech.verb) return const SizedBox.shrink();

    return VerbConjugationTable(
      rows: [
        VerbConjugationRowData(
          pronoun: '',
          controller: imperativeInformalController,
          inputHint: 'Informal',
          suffix: '!',
        ),
        VerbConjugationRowData(
          pronoun: '',
          controller: imperativeFormalController,
          inputHint: 'Formal',
          suffix: 'u !',
        ),
      ],
    );
  }
}
