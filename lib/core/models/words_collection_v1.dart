import 'package:first_project/core/models/base_words_collection.dart';
import 'package:first_project/core/models/word.dart';

const int collectionVersion = 1;

class WordsCollectionV1 extends BaseWordsCollection {
  final List<Word> words;

  WordsCollectionV1(this.words) : super(version: collectionVersion);

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }

  factory WordsCollectionV1.fromJson(Map<String, dynamic> json) {
    var wordsList = (json['words'] as List)
        .map((wordJson) => Word.fromJson(wordJson))
        .toList();

    return WordsCollectionV1(wordsList);
  }
}
