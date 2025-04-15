import 'package:dutch_app/core/models/new_word_collection.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/local_db/mapping/word_collections_mapper.dart';
import 'package:isar/isar.dart';

class WordCollectionsRepository {
  Future<int> addAsync(NewWordCollection wordCollection) async {
    final newCollection = WordCollectionsMapper.mapToEntity(wordCollection);
    newCollection.lastUpdated = DateTime.now();
    final int id = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.put(newCollection));
    return id;
  }

  Future<List<WordCollection>> getAsync() async {
    List<DbWordCollection> dbWordCollections =
        await DbContext.isar.dbWordCollections.where().findAll();
    List<WordCollection> result =
        WordCollectionsMapper.mapToDomainList(dbWordCollections);
    return result;
  }

  Future<WordCollection> getCollectionWithWordsAsync(int collectionId) async {
    var collection = await DbContext.isar.dbWordCollections.get(collectionId);
    if (collection == null) {
      throw Exception("Could not find collection with id $collectionId");
    }

    return await WordCollectionsMapper.mapWithWordsToDomainAsync(collection);
  }

  Future<List<WordCollection>> getCollectionsWithWordsAsync() async {
    List<DbWordCollection> dbWordCollections =
        await DbContext.isar.dbWordCollections.where().findAll();

    List<WordCollection> result =
        await WordCollectionsMapper.mapWithWordsToDomainListAsync(
            dbWordCollections);

    return result;
  }

  Future<bool> updateAsync(WordCollection updatedCollection) async {
    if (updatedCollection.id == null) {
      throw Exception(
          "Called collection update, but collection Id is null. Please refactor this code to rich domain model!");
    }

    final dbWordCollection =
        await DbContext.isar.dbWordCollections.get(updatedCollection.id!);

    if (dbWordCollection == null) {
      throw Exception(
          "Tried to update word ${updatedCollection.id}, but it was not found in database.");
    }

    dbWordCollection.name = updatedCollection.name;
    dbWordCollection.lastUpdated = DateTime.now();

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.put(dbWordCollection));

    return true;
  }

  Future<bool> deleteAsync(int id) async {
    return await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.delete(id));
  }
}
