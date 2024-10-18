import 'package:first_project/core/models/word.dart';
import 'package:first_project/local_db/entities/db_word.dart';

class WordsMapper {
  DbWord mapToEntity(Word word) {
    var newWord = DbWord();
    newWord.dutchWord = word.dutchWord;
    newWord.englishWord = word.englishWord;
    newWord.type = word.wordType;
    newWord.deHet = word.deHetType;
    newWord.pluralForm = word.pluralForm;
    newWord.tag = word.tag;
    return newWord;
  }

  List<DbWord> mapToEntityList(List<Word> words) {
    return words.map((word) => mapToEntity(word)).toList();
  }
}
