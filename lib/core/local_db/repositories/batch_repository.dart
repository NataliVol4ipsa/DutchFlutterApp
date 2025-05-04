import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/mapping/word_collections_mapper.dart';
import 'package:dutch_app/core/local_db/mapping/words_mapper.dart';

class BatchRepository {
  Future<void> importCollectionsAsync(
      List<NewWordCollection> newCollections) async {
    await DbContext.isar.writeTxn(() async {
      for (int i = 0; i < newCollections.length; i++) {
        if (CollectionPermissionService.isDefaultCollectionName(
            newCollections[i].name)) {
          await _importDefaultCollectionAsync(newCollections[i]);
        } else {
          await _importCollectionAsync(newCollections[i]);
        }
      }
    });
  }

  //no saving
  Future<void> _importCollectionAsync(NewWordCollection wordCollection) async {
    final newCollection = WordCollectionsMapper.mapToEntity(wordCollection);
    final newWords = WordsMapper.mapToEntityList(wordCollection.words);

    await DbContext.isar.dbWordCollections.put(newCollection);
    await DbContext.isar.dbWords.putAll(newWords);
    newCollection.words.addAll(newWords);
    await newCollection.words.save();
    await DbContext.isar.dbWordCollections.put(newCollection);
  }

  //no saving
  Future<void> _importDefaultCollectionAsync(
      NewWordCollection wordCollection) async {
    final defaultCollection = await DbContext.isar.dbWordCollections
        .get(CollectionPermissionService.defaultCollectionId);
    if (defaultCollection == null) {
      throw Exception("Could not find default collection");
    }

    final newWords = WordsMapper.mapToEntityList(wordCollection.words);

    await DbContext.isar.dbWords.putAll(newWords);
    defaultCollection.words.addAll(newWords);
    defaultCollection.lastUpdated = DateTime.now();
    await defaultCollection.words.save();
  }

  Future<void> deleteAsync(List<int> wordIds, List<int> collectionIds) async {
    await DbContext.isar.writeTxn(() async {
      await DbContext.isar.dbWords.deleteAll(wordIds);
      await DbContext.isar.dbWordCollections.deleteAll(collectionIds);
    });
  }
}
