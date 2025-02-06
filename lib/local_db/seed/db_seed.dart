import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:isar/isar.dart';

class CollectionConfig {
  static int defaultCollectionId = -1;
}

Future<int> seedDatabaseAsync() async {
  var isar = DbContext.isar;
  final DbWordCollection? defaultCollection =
      await isar.dbWordCollections.filter().nameEqualTo("Default").findFirst();

  if (defaultCollection != null) {
    CollectionConfig.defaultCollectionId = defaultCollection.id!;
    return defaultCollection.id!;
  }

  var newCollection = DbWordCollection();
  newCollection.name = "Default";

  await isar.writeTxn(() async {
    await isar.dbWordCollections.put(newCollection);
  });

  CollectionConfig.defaultCollectionId = newCollection.id!;
  return newCollection.id!;
}
