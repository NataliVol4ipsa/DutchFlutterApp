import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_row_data.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/generic/verb_conjugation_table.dart';
import 'package:flutter/material.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class VerbPresentTenseTab extends StatelessWidget {
  final PartOfSpeech Function() wordTypeGetter;
  final TextEditingController presentTenseIkController;
  final TextEditingController presentTenseJijVraagController;
  final TextEditingController presentTenseJijController;
  final TextEditingController presentTenseUController;
  final TextEditingController presentTenseHijZijHetController;
  final TextEditingController presentTenseWijController;
  final TextEditingController presentTenseJullieController;
  final TextEditingController presentTenseZijController;

  const VerbPresentTenseTab({
    super.key,
    required this.wordTypeGetter,
    required this.presentTenseIkController,
    required this.presentTenseJijVraagController,
    required this.presentTenseJijController,
    required this.presentTenseUController,
    required this.presentTenseHijZijHetController,
    required this.presentTenseWijController,
    required this.presentTenseJullieController,
    required this.presentTenseZijController,
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
          controller: presentTenseIkController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: '',
          controller: presentTenseJijVraagController,
          suffix: 'jij?',
        ),
        VerbConjugationRowData(
          pronoun: 'jij',
          controller: presentTenseJijController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'u',
          controller: presentTenseUController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'hij/zij/het',
          controller: presentTenseHijZijHetController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'wij',
          controller: presentTenseWijController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'jullie',
          controller: presentTenseJullieController,
          suffix: '.',
        ),
        VerbConjugationRowData(
          pronoun: 'zij',
          controller: presentTenseZijController,
          suffix: '.',
        ),
      ],
    );
  }
}
