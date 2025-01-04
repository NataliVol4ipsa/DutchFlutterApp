import 'package:dutch_app/core/dtos/word_dto.dart';
import 'package:dutch_app/core/dtos/words_collection_dto_v1.dart';
import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

class WordsIoMapper {
  WordsCollectionDtoV1 toCollectionDto(List<Word> inputWords) {
    return WordsCollectionDtoV1(
        inputWords.map((word) => WordDto.fromWord(word)).toList());
  }

  NewWord toNewWord(WordDto source) {
    if (source.dutchWord == null) {
      throw Exception("Cannot create word without dutchWord");
    }
    if (source.englishWord == null) {
      throw Exception("Cannot create word without englishWord");
    }
    var wordType = source.wordType ?? WordType.none;
    var deHetType = source.deHetType ?? DeHetType.none;
    return NewWord(source.dutchWord!, source.englishWord!, wordType,
        deHetType: deHetType, pluralForm: source.pluralForm, tag: source.tag);
  }

  List<NewWord> toNewWordsListV1(WordsCollectionDtoV1 collection) {
    return collection.words.map((wordDto) => toNewWord(wordDto)).toList();
  }
}
