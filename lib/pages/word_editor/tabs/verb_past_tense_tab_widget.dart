import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_row_data.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_table.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class VerbPastTenseTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController pastTenseIkController;
  final TextEditingController pastTenseJijController;
  final TextEditingController pastTenseHijZijHetController;
  final TextEditingController pastTenseWijController;
  final TextEditingController pastTenseJullieController;
  final TextEditingController pastTenseZijController;

  const VerbPastTenseTab({
    super.key,
    required this.wordTypeGetter,
    required this.pastTenseIkController,
    required this.pastTenseJijController,
    required this.pastTenseHijZijHetController,
    required this.pastTenseWijController,
    required this.pastTenseJullieController,
    required this.pastTenseZijController,
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
          pronoun: 'ik',
          controller: pastTenseIkController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'jij',
          controller: pastTenseJijController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'hij/zij/het',
          controller: pastTenseHijZijHetController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'wij',
          controller: pastTenseWijController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'jullie',
          controller: pastTenseJullieController,
          suffix: '.',
        ),
      ],
    );
  }
}
