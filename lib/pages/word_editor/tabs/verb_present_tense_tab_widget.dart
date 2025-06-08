import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_hijZijHet_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_ik_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_jijVraag_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_jij_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_jullie_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_u_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_wij_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/verb/present_tense_zij_input_widget.dart';
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
    return Column(
      children: [
        if (wordTypeGetter() == PartOfSpeech.verb) ...[
          PresentTenseIkInput(textEditingController: presentTenseIkController),
          PresentTenseJijVraagInput(
              textEditingController: presentTenseJijVraagController),
          PresentTenseJijInput(
              textEditingController: presentTenseJijController),
          PresentTenseUInput(textEditingController: presentTenseUController),
          PresentTenseHijZijHetInput(
              textEditingController: presentTenseHijZijHetController),
          PresentTenseWijInput(
              textEditingController: presentTenseWijController),
          PresentTenseJullieInput(
              textEditingController: presentTenseJullieController),
          PresentTenseZijInput(
              textEditingController: presentTenseZijController),
        ]
      ],
    );
  }
}
