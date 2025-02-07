import 'package:dutch_app/core/services/collection_permission_service.dart';
import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:isar/isar.dart';

Future<void> seedDatabaseAsync() async {
  DbWordCollection defaultCollection =
      await getOrCreateDefaultCollectionIdAsync();
  CollectionPermissionService.defaultCollectionId = defaultCollection.id!;

  await setDefaultCollectionForExistingWordsAsync(defaultCollection);
}

Future<DbWordCollection> getOrCreateDefaultCollectionIdAsync() async {
  var isar = DbContext.isar;
  final DbWordCollection? defaultCollection = await isar.dbWordCollections
      .filter()
      .nameEqualTo(CollectionPermissionService.defaultCollectionName)
      .findFirst();

  if (defaultCollection != null) {
    return defaultCollection;
  }

  var newCollection = DbWordCollection();
  newCollection.name = CollectionPermissionService.defaultCollectionName;

  await isar.writeTxn(() async {
    await isar.dbWordCollections.put(newCollection);
  });

  return newCollection;
}

Future<void> setDefaultCollectionForExistingWordsAsync(
    DbWordCollection defaultCollection) async {
  var isar = DbContext.isar;
  List<DbWord> wordsWithoutCollections =
      await isar.dbWords.filter().collectionIsNull().findAll();

  await DbContext.isar.writeTxn(() async {
    defaultCollection.words.addAll(wordsWithoutCollections);
    defaultCollection.words.save();
  });
}
