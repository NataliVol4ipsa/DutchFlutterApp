import 'package:first_project/core/models/word.dart';
import 'package:first_project/local_db/entities/db_word.dart';
import 'package:first_project/local_db/mapping/words_mapper.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbContext {
  static late Isar isar;

  static Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([DbWordSchema], directory: appDir.path);
  }

  Future<int> addWordAsync(Word word) async {
    final newWord = WordsMapper().mapToEntity(word);
    final int id = await isar.writeTxn(() => isar.dbWords.put(newWord));
    return id;
  }

  Future<List<int>> addWordsAsync(List<Word> words) async {
    final newWords = WordsMapper().mapToEntityList(words);

    final List<int> ids =
        await isar.writeTxn(() => isar.dbWords.putAll(newWords));

    return ids;
  }

  Future<bool> updateWordAsync(Word updatedWord) async {
    if (updatedWord.id == null) {
      throw Exception(
          "Called word update, but word Id is null. Please refactor this code to rich domain model!");
    }

    final dbWord = await isar.dbWords.get(updatedWord.id!);

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

    await isar.writeTxn(() => isar.dbWords.put(dbWord));

    return true;
  }

  Future<List<Word>> getWordsAsync() async {
    List<DbWord> dbWords = await isar.dbWords.where().findAll();
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

  Future<Word?> getWordAsync(int id) async {
    final dbWord = await isar.dbWords.get(id);

    if (dbWord == null) return null;

    return Word(
      dbWord.id,
      dbWord.dutchWord,
      dbWord.englishWord,
      dbWord.type,
      deHetType: dbWord.deHet,
      pluralForm: dbWord.pluralForm,
      tag: dbWord.tag,
    );
  }

  Future<bool> deleteAsync(int id) async {
    return await isar.writeTxn(() => isar.dbWords.delete(id));
  }

  Future<int> deleteBatchAsync(List<int> ids) async {
    return await isar.writeTxn(() => isar.dbWords.deleteAll(ids));
  }
}
