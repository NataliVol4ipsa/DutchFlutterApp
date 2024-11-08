import 'package:first_project/core/dtos/word_dto.dart';
import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';

class WordsMapper {
  WordsCollectionDtoV1 toCollectionDto(List<Word> inputWords) {
    return WordsCollectionDtoV1(
        inputWords.map((word) => WordDto.fromWord(word)).toList());
  }

  Word toWord(WordDto source) {
    if (source.dutchWord == null) {
      throw Exception("Cannot create word without dutchWord");
    }
    if (source.englishWord == null) {
      throw Exception("Cannot create word without englishWord");
    }
    var wordType = source.wordType ?? WordType.none;
    var deHetType = source.deHetType ?? DeHetType.none;
    return Word(null, source.dutchWord!, source.englishWord!, wordType,
        deHetType: deHetType, pluralForm: source.pluralForm, tag: source.tag);
  }

  List<Word> toWordsListV1(WordsCollectionDtoV1 collection) {
    return collection.words.map((wordDto) => toWord(wordDto)).toList();
  }
}
