import 'package:first_project/core/dtos/base_words_collection_dto.dart';
import 'package:first_project/core/dtos/word_dto.dart';

const int collectionVersion = 1;

class WordsCollectionDtoV1 extends BaseWordsCollectionDto {
  final List<WordDto> words;

  WordsCollectionDtoV1(this.words) : super(version: collectionVersion);

  Map<String, dynamic> toJson() {
    return {
      'version': version,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }

  factory WordsCollectionDtoV1.fromJson(Map<String, dynamic> json) {
    var wordsList = (json['words'] as List)
        .map((wordJson) => WordDto.fromJson(wordJson))
        .toList();

    return WordsCollectionDtoV1(wordsList);
  }
}
