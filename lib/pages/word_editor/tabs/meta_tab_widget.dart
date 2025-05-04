import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/pages/word_editor/inputs/context_example_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/context_example_translation_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/user_note_input_widget.dart';
import 'package:flutter/material.dart';

class MetaTab extends StatelessWidget {
  final TextEditingController contextExampleController;
  final TextEditingController contextExampleTranslationController;
  final TextEditingController userNoteController;

  const MetaTab({
    super.key,
    required this.contextExampleController,
    required this.contextExampleTranslationController,
    required this.userNoteController,
  });

  static bool shouldShowTab(WordType wordType) {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ContextExampleInput(
          textEditingController: contextExampleController,
        ),
        ContextExampleTranslationInput(
          textEditingController: contextExampleTranslationController,
        ),
        UserNoteInput(
          textEditingController: userNoteController,
        ),
      ],
    );
  }
}
