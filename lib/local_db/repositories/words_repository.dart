import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

import '../mapping/words_mapper.dart';

class WordsRepository {
  Future<int> addAsync(Word word) async {
    final newWord = WordsMapper().mapToEntity(word);
    final int id = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.put(newWord));
    return id;
  }

  Future<List<int>> addBatchAsync(List<Word> words) async {
    final newWords = WordsMapper().mapToEntityList(words);

    final List<int> ids = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWords.putAll(newWords));

    return ids;
  }

  Future<List<Word>> getAsync() async {
    List<DbWord> dbWords = await DbContext.isar.dbWords.where().findAll();
    List<Word> words = dbWords
        .map((dbWord) => Word(
              dbWord.id,
              dbWord.dutchWord,
              dbWord.englishWord,
              dbWord.type,
              deHetType: dbWord.deHet,
              pluralForm: dbWord.pluralForm,
              tag: dbWord.tag,
            ))
        .toList();
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
