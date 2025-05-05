import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/mapping/words_mapper.dart';

class WordCollectionsMapper {
  static DbWordCollection mapToEntity(NewWordCollection collection) {
    var newCollection = DbWordCollection();
    newCollection.name = collection.name;
    newCollection.lastUpdated = DateTime.now();
    return newCollection;
  }

  static List<DbWordCollection> mapToEntityList(
      List<NewWordCollection> collections) {
    return collections.map((collection) => mapToEntity(collection)).toList();
  }

  static WordCollection? mapToDomain(DbWordCollection? dbCollection) {
    if (dbCollection == null) {
      return null;
    }

    var collection = WordCollection(dbCollection.id, dbCollection.name,
        lastUpdated: dbCollection.lastUpdated);
    return collection;
  }

  static Future<WordCollection> mapWithWordsToDomainAsync(
      DbWordCollection dbCollection) async {
    await dbCollection.words.load();

    if (dbCollection.words.isNotEmpty) {
      await Future.wait([
        ...dbCollection.words.map((w) => w.dutchWordLink.load()),
        ...dbCollection.words.map((w) => w.englishWordLinks.load()),
      ]);
    }

    WordCollection newCollection = WordCollection(
        dbCollection.id, dbCollection.name,
        lastUpdated: dbCollection.lastUpdated,
        words: WordsMapper.mapToDomainList(dbCollection.words.toList()));

    return newCollection;
  }

  static List<WordCollection> mapToDomainList(
      List<DbWordCollection> collections) {
    return collections
        .map((collection) => mapToDomain(collection))
        .whereType<WordCollection>()
        .toList();
  }

  static Future<List<WordCollection>> mapWithWordsToDomainListAsync(
      List<DbWordCollection> collections) async {
    return Future.wait(
        collections.map((collection) => mapWithWordsToDomainAsync(collection)));
  }
}
