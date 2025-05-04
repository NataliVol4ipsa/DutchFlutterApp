import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/pages/word_editor/inputs/collection_dropdown_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/dehet_optional_toggle_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/dutch_word_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/english_word_input_widget.dart';
import 'package:dutch_app/pages/word_editor/inputs/word_type_dropdown_input_widget.dart';
import 'package:flutter/material.dart';

class MainTab extends StatelessWidget {
  final WordType Function() wordTypeGetter;
  final TextEditingController dutchWordController;
  final TextEditingController englishWordController;
  final ValueNotifier<WordType> wordTypeValueNotifier;
  final ValueNotifier<WordCollection> collectionValueNotifier;
  final ValueNotifier<DeHetType> deHetValueNotifier;

  const MainTab({
    super.key,
    required this.dutchWordController,
    required this.englishWordController,
    required this.wordTypeValueNotifier,
    required this.collectionValueNotifier,
    required this.wordTypeGetter,
    required this.deHetValueNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DutchWordInput(
          textEditingController: dutchWordController,
        ),
        EnglishWordInput(
          textEditingController: englishWordController,
        ),
        WordTypeDropdownInput(
          valueNotifier: wordTypeValueNotifier,
        ),
        CollectionDropdownInput(
          valueNotifier: collectionValueNotifier,
        ),
        if (wordTypeGetter() == WordType.noun)
          DeHetOptionalToggleInput(valueNotifier: deHetValueNotifier),
      ],
    );
  }
}
