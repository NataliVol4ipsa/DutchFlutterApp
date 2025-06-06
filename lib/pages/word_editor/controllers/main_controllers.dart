import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:flutter/material.dart';

class MainControllers {
  final TextEditingController dutchWordController = TextEditingController();
  final TextEditingController englishWordController = TextEditingController();
  final ValueNotifier<PartOfSpeech> wordTypeController =
      ValueNotifier<PartOfSpeech>(PartOfSpeech.unspecified);
  final ValueNotifier<WordCollection> wordCollectionController =
      ValueNotifier<WordCollection>(WordCollection(
          CollectionPermissionService.defaultCollectionId,
          CollectionPermissionService.defaultCollectionName));
  final TextEditingController contextExampleController =
      TextEditingController();
  final TextEditingController contextExampleTranslationController =
      TextEditingController();
  final TextEditingController userNoteController = TextEditingController();

  void initializeFromWord(Word word) {
    dutchWordController.text = word.dutchWord;
    englishWordController.text =
        SemicolonWordsConverter.toSingleString(word.englishWords);
    wordTypeController.value = word.partOfSpeech;
    wordCollectionController.value =
        word.collection ?? wordCollectionController.value;
    contextExampleController.text = word.contextExample ?? "";
    contextExampleTranslationController.text =
        word.contextExampleTranslation ?? "";
    userNoteController.text = word.userNote ?? "";
  }
}
