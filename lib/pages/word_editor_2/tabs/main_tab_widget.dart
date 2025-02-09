import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/collection_dropdown_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/dutch_word_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/english_word_input_widget.dart';
import 'package:dutch_app/pages/word_editor_2/inputs/word_type_dropdown_input_widget.dart';
import 'package:flutter/material.dart';

class MainTab extends StatelessWidget {
  final TextEditingController dutchWordController;
  final TextEditingController englishWordController;
  final ValueNotifier<WordType> wordTypeValueNotifier;
  final ValueNotifier<WordCollection> collectionValueNotifier;

  const MainTab({
    super.key,
    required this.dutchWordController,
    required this.englishWordController,
    required this.wordTypeValueNotifier,
    required this.collectionValueNotifier,
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
      ],
    );
  }
}
