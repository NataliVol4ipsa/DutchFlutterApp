import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/mapping/word_collections_mapper.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/models/word_verb_details.dart';

class WordsMapper {
  static DbWord mapToEntity(NewWord word) {
    var newWord = DbWord();
    newWord.type = word.partOfSpeech;
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

//todo semicolon into array
    return Word(
      dbWord.id!,
      dbWord.dutchWordLink.value?.word ?? "ERROR",
      dbWord.englishWordLinks.map((l) => l.word).toList(),
      dbWord.type,
      collection: WordCollectionsMapper.mapToDomain(dbWord.collection.value),
      contextExample: dbWord.contextExample,
      contextExampleTranslation: dbWord.contextExampleTranslation,
      userNote: dbWord.userNote,
      audioCode: dbWord.dutchWordLink.value?.audioCode,
      nounDetails: _mapNounDetailsToDomain(dbWord.nounDetailsLink.value),
      verbDetails: _mapVerbDetailsToDomain(dbWord.verbDetailsLink.value),
    );
  }

  static WordNounDetails? _mapNounDetailsToDomain(DbWordNounDetails? details) {
    if (details == null) return null;
    return WordNounDetails(
        deHetType: details.deHet,
        diminutive: details.diminutiveWordLink.value?.word,
        pluralForm: details.pluralFormWordLink.value?.word);
  }

  static WordVerbDetails? _mapVerbDetailsToDomain(DbWordVerbDetails? details) {
    if (details == null) return null;
    return WordVerbDetails();
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
