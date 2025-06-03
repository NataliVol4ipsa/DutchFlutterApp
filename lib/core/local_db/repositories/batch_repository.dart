import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';

class BatchRepository {
  Future<void> deleteAsync(List<int> wordIds, List<int> collectionIds) async {
    final words = await DbContext.isar.dbWords.getAll(wordIds);

    final nounDetailIds = <int>[];
    final verbDetailIds = <int>[];

    for (final word in words.whereType<DbWord>()) {
      await word.nounDetailsLink.load();
      await word.verbDetailsLink.load();

      if (word.nounDetailsLink.value?.id case final id?) nounDetailIds.add(id);
      if (word.verbDetailsLink.value?.id case final id?) verbDetailIds.add(id);
    }

    await DbContext.isar.writeTxn(() async {
      await DbContext.isar.dbWordNounDetails.deleteAll(nounDetailIds);
      await DbContext.isar.dbWordVerbDetails.deleteAll(verbDetailIds);
      await DbContext.isar.dbWords.deleteAll(wordIds);
      await DbContext.isar.dbWordCollections.deleteAll(collectionIds);
    });
  }
}
