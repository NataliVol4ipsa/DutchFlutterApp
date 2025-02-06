import 'package:dutch_app/core/models/new_word_collection.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/local_db/mapping/words_mapper.dart';

class WordCollectionsMapper {
  static DbWordCollection mapToEntity(NewWordCollection collection) {
    var newCollection = DbWordCollection();
    newCollection.name = collection.name;
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

    var collection = WordCollection(dbCollection.id, dbCollection.name);
    return collection;
  }

  static Future<WordCollection> mapWithWordsToDomainAsync(
      DbWordCollection dbCollection) async {
    await dbCollection.words.load();

    WordCollection newCollection = WordCollection(
        dbCollection.id, dbCollection.name,
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
