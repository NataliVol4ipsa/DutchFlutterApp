// import 'package:dutch_app/domain/models/new_word.dart';
// import 'package:dutch_app/domain/services/collection_permission_service.dart';
// import 'package:dutch_app/core/local_db/db_context.dart';
// import 'package:dutch_app/domain/models/word.dart';
// import 'package:dutch_app/core/local_db/entities/db_word.dart';
// import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
// import 'package:isar/isar.dart';

// import '../mapping/words_mapper.dart';

// class WordsRepository {
//   Future<int> addAsync(NewWord word) async {
//     final newWord = WordsMapper.mapToEntity(word);
//     int collectionId =
//         word.collection?.id ?? CollectionPermissionService.defaultCollectionId;

//     return await addNewWordToCollectionAsync(collectionId, newWord);
//   }

//   Future<int> addNewWordToCollectionAsync(
//       int collectionId, DbWord newWord) async {
//     int newWordId = -1;

//     await DbContext.isar.writeTxn(() async {
//       final collection =
//           await DbContext.isar.dbWordCollections.get(collectionId);
//       if (collection != null) {
//         newWordId = await DbContext.isar.dbWords.put(newWord);
//         collection.words.add(newWord);
//         await collection.words.save();
//         collection.lastUpdated = DateTime.now();
//         await DbContext.isar.dbWordCollections.put(collection);
//       } else {
//         throw Exception("Could not find collection with id $collectionId");
//       }
//     });

//     return newWordId;
//   }

//   Future<void> addExistingWordToCollectionAsync(
//       int collectionId, DbWord word) async {
//     await DbContext.isar.writeTxn(() async {
//       final collection =
//           await DbContext.isar.dbWordCollections.get(collectionId);
//       if (collection != null) {
//         collection.words.add(word);
//         await collection.words.save();
//         collection.lastUpdated = DateTime.now();
//         await DbContext.isar.dbWordCollections.put(collection);
//       }
//     });
//   }

//   Future<void> removeWordFromCollectionAsync(DbWord word) async {
//     if (word.collection.value?.id == null) return;

//     await DbContext.isar.writeTxn(() async {
//       final oldCollection = await DbContext.isar.dbWordCollections
//           .get(word.collection.value!.id!);
//       if (oldCollection != null) {
//         oldCollection.words.remove(word);
//         await oldCollection.words.save();
//       }
//     });
//   }

//   Future<List<int>> addBatchAsync(List<NewWord> words) async {
//     final newWords = WordsMapper.mapToEntityList(words);

//     final List<int> ids = await DbContext.isar
//         .writeTxn(() => DbContext.isar.dbWords.putAll(newWords));

//     return ids;
//   }

//   Future<List<Word>> getWordsAsync() async {
//     List<DbWord> dbWords = await DbContext.isar.dbWords.where().findAll();
//     List<Word> words = WordsMapper.mapToDomainList(dbWords);
//     return words;
//   }

//   Future<List<Word>> getWordsWithCollectionAsync() async {
//     List<DbWord> dbWords = await DbContext.isar.dbWords.where().findAll();
//     List<Word> words =
//         await WordsMapper.mapWithCollectionToDomainListAsync(dbWords);
//     return words;
//   }

//   Future<Word?> getWordAsync(int wordId) async {
//     final DbWord? dbWord = await DbContext.isar.dbWords.get(wordId);

//     await dbWord?.collection.load();

//     Word? word = WordsMapper.mapToDomain(dbWord);
//     return word;
//   }

//   Future<bool> updateAsync(Word updatedWord) async {
//     final dbWord = await DbContext.isar.dbWords.get(updatedWord.id);

//     if (dbWord == null) {
//       throw Exception(
//           "Tried to update word ${updatedWord.id}, but it was not found in database.");
//     }

//     await dbWord.collection.load();

//     mapUpdatedWordToEntity(dbWord, updatedWord);

//     await DbContext.isar.writeTxn(() => DbContext.isar.dbWords.put(dbWord));

//     if (dbWord.collection.value?.id != updatedWord.collection?.id) {
//       await removeWordFromCollectionAsync(dbWord);
//       if (updatedWord.collection?.id != null) {
//         await addExistingWordToCollectionAsync(
//             updatedWord.collection!.id!, dbWord);
//       }
//     }
//     return true;
//   }

//   void mapUpdatedWordToEntity(DbWord dbWord, Word updatedWord) {
//     dbWord.dutchWord = updatedWord.dutchWord;
//     dbWord.englishWord = updatedWord.englishWord;
//     dbWord.type = updatedWord.wordType;
//     dbWord.deHet = updatedWord.deHetType;
//     dbWord.pluralForm = updatedWord.pluralForm;
//     dbWord.contextExample = updatedWord.contextExample;
//     dbWord.contextExampleTranslation = updatedWord.contextExampleTranslation;
//     dbWord.userNote = updatedWord.userNote;
//   }

//   Future<bool> deleteAsync(int id) async {
//     return await DbContext.isar
//         .writeTxn(() => DbContext.isar.dbWords.delete(id));
//   }

//   Future<int> deleteBatchAsync(List<int> ids) async {
//     return await DbContext.isar
//         .writeTxn(() => DbContext.isar.dbWords.deleteAll(ids));
//   }
// }
