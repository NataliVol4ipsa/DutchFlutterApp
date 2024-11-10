import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/local_db/entities/db_word.dart';
import 'package:first_project/local_db/entities/db_word_collection.dart';
import 'package:isar/isar.dart';

import '../mapping/words_mapper.dart';

class WordsRepository {
  Future<int> addAsync(Word word) async {
    final newWord = WordsMapper.mapToEntity(word);
    int? collectionId = word.collection?.id;
    if (collectionId != null) {
      addWordToCollectionAsync(collectionId, newWord);
    }
    final int id = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.put(newWord));
    return id;
  }

  Future<int> addWordToCollectionAsync(int collectionId, DbWord newWord) async {
    int newWordId = -1;
    // Transaction
    await DbContext.isar.writeTxn(() async {
      final collection =
          await DbContext.isar.dbWordCollections.get(collectionId);
      if (collection != null) {
        newWordId = await DbContext.isar.dbWords.put(newWord);
        collection.words.add(newWord);
        await collection.words.save();
        await DbContext.isar.dbWordCollections.put(collection);
      } else {
        throw Exception("Could not find collection with id $collectionId");
      }
    });

    return newWordId;
  }

  Future<List<int>> addBatchAsync(List<Word> words) async {
    final newWords = WordsMapper.mapToEntityList(words);

    final List<int> ids = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.putAll(newWords));

    return ids;
  }

  Future<List<Word>> getAsync() async {
    List<DbWord> dbWords = await DbContext.isar.dbWords.where().findAll();
    List<Word> words =
        dbWords.map((dbWord) => WordsMapper.mapToDomain(dbWord)).toList();
    return words;
  }

  Future<bool> updateAsync(Word updatedWord) async {
    if (updatedWord.id == null) {
      throw Exception(
          "Called word update, but word Id is null. Please refactor this code to rich domain model!");
    }

    final dbWord = await DbContext.isar.dbWords.get(updatedWord.id!);

    if (dbWord == null) {
      throw Exception(
          "Tried to update word ${updatedWord.id}, but it was not found in database.");
    }

    dbWord.dutchWord = updatedWord.dutchWord;
    dbWord.englishWord = updatedWord.englishWord;
    dbWord.type = updatedWord.wordType;
    dbWord.deHet = updatedWord.deHetType;
    dbWord.pluralForm = updatedWord.pluralForm;
    dbWord.tag = updatedWord.tag;

    await DbContext.isar.writeTxn(() => DbContext.isar.dbWords.put(dbWord));

    return true;
  }

  Future<bool> deleteAsync(int id) async {
    return await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.delete(id));
  }

  Future<int> deleteBatchAsync(List<int> ids) async {
    return await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.deleteAll(ids));
  }
}
