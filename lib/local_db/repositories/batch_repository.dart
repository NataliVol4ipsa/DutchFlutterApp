import 'package:dutch_app/core/models/new_word_collection.dart';
import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/local_db/mapping/word_collections_mapper.dart';
import 'package:dutch_app/local_db/mapping/words_mapper.dart';

class BatchRepository {
  Future<void> importCollectionsAsync(
      List<NewWordCollection> newCollections) async {
    await DbContext.isar.writeTxn(() async {
      for (int i = 0; i < newCollections.length; i++) {
        await _importCollectionAsync(newCollections[i]);
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
}
