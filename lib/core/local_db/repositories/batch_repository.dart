import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';

class BatchRepository {
  Future<void> deleteAsync(List<int> wordIds, List<int> collectionIds) async {
    await DbContext.isar.writeTxn(() async {
      await DbContext.isar.dbWords.deleteAll(wordIds);
      await DbContext.isar.dbWordCollections.deleteAll(collectionIds);
    });
  }
}
