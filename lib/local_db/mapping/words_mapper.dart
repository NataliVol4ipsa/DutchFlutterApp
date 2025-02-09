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
    newWord.contextExample = word.contextExample;
    newWord.contextExampleTranslation = word.contextExampleTranslation;
    newWord.userNote = word.userNote;
    return newWord;
  }

  static List<DbWord> mapToEntityList(List<NewWord> words) {
    return words.map((word) => mapToEntity(word)).toList();
  }

  static Word? mapToDomain(DbWord? dbWord) {
    if (dbWord == null) {
      return null;
    }

    return Word(
      dbWord.id!,
      dbWord.dutchWord,
      dbWord.englishWord,
      dbWord.type,
      collection: WordCollectionsMapper.mapToDomain(dbWord.collection.value),
      deHetType: dbWord.deHet,
      pluralForm: dbWord.pluralForm,
      contextExample: dbWord.contextExample,
      contextExampleTranslation: dbWord.contextExampleTranslation,
      userNote: dbWord.userNote,
    );
  }

  static List<Word> mapToDomainList(List<DbWord> words) {
    return words.map((word) => mapToDomain(word)).whereType<Word>().toList();
  }

  static Future<Word> mapWithCollectionToDomainAsync(DbWord dbWord) async {
    await dbWord.collection.load();
    return mapToDomain(dbWord)!;
  }

  static Future<List<Word>> mapWithCollectionToDomainListAsync(
      List<DbWord> words) {
    return Future.wait(
        words.map((word) => mapWithCollectionToDomainAsync(word)));
  }
}
