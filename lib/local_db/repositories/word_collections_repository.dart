import 'package:first_project/core/models/word_collection.dart';
import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/local_db/entities/db_word_collection.dart';
import 'package:first_project/local_db/mapping/word_collections_mapper.dart';
import 'package:isar/isar.dart';

class WordCollectionsRepository {
  Future<int> addAsync(WordCollection wordCollection) async {
    final newCollection = WordCollectionsMapper().mapToEntity(wordCollection);
    final int id = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.put(newCollection));
    return id;
  }

  Future<List<WordCollection>> getAsync() async {
    List<DbWordCollection> dbWordCollections =
        await DbContext.isar.dbWordCollections.where().findAll();
    List<WordCollection> result = dbWordCollections
        .map((dbWordCollection) =>
            WordCollection(dbWordCollection.id, dbWordCollection.name))
        .toList();
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

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.put(dbWordCollection));

    return true;
  }

  Future<bool> deleteAsync(int id) async {
    return await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordCollections.delete(id));
  }
}
