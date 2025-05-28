import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/services/batch_word_operations_service.dart';
import 'package:dutch_app/domain/services/word_collection_sorter.dart';
import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/core/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection_model.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WordCollectionListManager {
  late WordCollectionsRepository collectionsRepository;
  late BatchWordOperationsService wordsStorageService;
  List<SelectableWordCollectionModel> collections = [];

  WordCollectionListManager(BuildContext context) {
    collectionsRepository = context.read<WordCollectionsRepository>();
    wordsStorageService = context.read<BatchWordOperationsService>();
  }

  Future<void> loadCollectionsAsync() async {
    var dbCollections =
        await collectionsRepository.getCollectionsWithWordsAsync();

    collections =
        dbCollections //todo use more lightweight models to prevent lag for 600k words
            .map((col) => SelectableWordCollectionModel(col.id!, col.name,
                col.words?.map((word) => SelectableWordModel(word)).toList(),
                lastUpdated: col.lastUpdated))
            .toList();
//      words!.sort((w1, w2) => w1.value.dutchWord.compareTo(w2.value.dutchWord));
    WordCollectionSorter.sort(collections);

    for (var col in collections) {
      if (col.words != null) col.words!.sort(_sortWords);
    }
  }

  int _sortWords(SelectableWordModel w1, SelectableWordModel w2) {
    if (w1.value.wordType == WordType.phrase &&
        w2.value.wordType == WordType.phrase) {
      return w1.value.dutchWord
          .toLowerCase()
          .compareTo(w2.value.dutchWord.toLowerCase());
    }
    if (w1.value.wordType == WordType.phrase) {
      return 1;
    }
    if (w2.value.wordType == WordType.phrase) {
      return -1;
    }
    return w1.value.dutchWord
        .toLowerCase()
        .compareTo(w2.value.dutchWord.toLowerCase());
  }

  void unselectWordsAndCollections() {
    for (var collection in collections) {
      collection.isSelected = false;
      for (var word in collection.words ?? []) {
        word.isSelected = false;
      }
    }
  }

  List<int> getAllSelectedWordIds() {
    List<int> wordIds = [];

    for (var collection in collections) {
      wordIds.addAll(collection.getSelectedWords().map((word) => word.id));
    }
    return wordIds;
  }

  List<Word> getAllSelectedWords() {
    List<Word> words = [];

    for (var collection in collections) {
      words.addAll(collection.getSelectedWords());
    }
    return words;
  }

  int calculateSelectedWords() {
    int answer = 0;

    for (var collection in collections) {
      for (var word in collection.words ?? []) {
        if (word.isSelected) {
          answer++;
        }
      }
    }
    return answer;
  }

  List<WordCollection> getCollectionsWithAtLeastOneSelectedWord() {
    List<WordCollection> result = [];
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].isSelected || collections[i].containsSelectedWords()) {
        result.add(WordCollection(collections[i].id, collections[i].name,
            words: collections[i].getSelectedWords()));
      }
    }
    return result;
  }

  bool containsAtLeastOneSelectedItem() {
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].isSelected || collections[i].containsSelectedWords()) {
        return true;
      }
    }

    return false;
  }

  bool containsAtLeastOneSelectedWord() {
    for (int i = 0; i < collections.length; i++) {
      if (collections[i].containsSelectedWords()) {
        return true;
      }
    }

    return false;
  }

  void makeAllWordsAndCollectionsVisible() {
    for (var collection in collections) {
      collection.isVisible = true;
      for (var word in collection.words ?? []) {
        word.isVisible = true;
      }
    }
  }

  void adjustVisibilityBySearchTerm(String searchTerm) {
    searchTerm = searchTerm.toLowerCase();
    for (var collection in collections) {
      bool hasVisibleWords = false;
      for (var word in collection.words ?? []) {
        if (word.value.dutchWord.toLowerCase().contains(searchTerm)) {
          word.isVisible = true;
          hasVisibleWords = true;
        } else {
          word.isVisible = false;
        }
      }
      if (collection.name.toLowerCase().contains(searchTerm)) {
        collection.isVisible = true;
      } else {
        collection.isVisible = hasVisibleWords;
      }
    }
  }
}
