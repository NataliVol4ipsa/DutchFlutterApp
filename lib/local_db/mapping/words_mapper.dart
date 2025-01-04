import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:dutch_app/local_db/mapping/word_collections_mapper.dart';

class WordsMapper {
  static DbWord mapToEntity(NewWord word) {
    var newWord = DbWord();
    newWord.dutchWord = word.dutchWord;
    newWord.englishWord = word.englishWord;
    newWord.type = word.wordType;
    newWord.deHet = word.deHetType;
    newWord.pluralForm = word.pluralForm;
    newWord.tag = word.tag;
    return newWord;
  }

  static List<DbWord> mapToEntityList(List<NewWord> words) {
    return words.map((word) => mapToEntity(word)).toList();
  }

  static Word mapToDomain(DbWord dbWord) {
    return Word(
      dbWord.id!,
      dbWord.dutchWord,
      dbWord.englishWord,
      dbWord.type,
      deHetType: dbWord.deHet,
      pluralForm: dbWord.pluralForm,
      tag: dbWord.tag,
    );
  }

  static List<Word> mapToDomainList(List<DbWord> words) {
    return words.map((word) => mapToDomain(word)).toList();
  }

  static Future<Word> mapWithCollectionToDomainAsync(DbWord dbWord) async {
    await dbWord.collection.load();
    return Word(
      dbWord.id!,
      dbWord.dutchWord,
      dbWord.englishWord,
      dbWord.type,
      deHetType: dbWord.deHet,
      pluralForm: dbWord.pluralForm,
      tag: dbWord.tag,
      collection:
          WordCollectionsMapper.mapNullableToDomain(dbWord.collection.value),
    );
  }

  static Future<List<Word>> mapWithCollectionToDomainListAsync(
      List<DbWord> words) {
    return Future.wait(
        words.map((word) => mapWithCollectionToDomainAsync(word)));
  }
}
