import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_hijZijHet_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_ik_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_jij_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_jullie_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_wij_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/past_tense_zij_input_widget.dart';
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
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.verb) ...[
          PastTenseIkInput(textEditingController: pastTenseIkController),
          PastTenseJijInput(textEditingController: pastTenseJijController),
          PastTenseHijZijHetInput(
              textEditingController: pastTenseHijZijHetController),
          PastTenseWijInput(textEditingController: pastTenseWijController),
          PastTenseJullieInput(
              textEditingController: pastTenseJullieController),
          PastTenseZijInput(textEditingController: pastTenseZijController),
        ]
      ],
    );
  }
}
