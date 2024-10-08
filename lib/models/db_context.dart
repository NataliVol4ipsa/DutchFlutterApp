import 'package:first_project/models/db_word.dart';
import 'package:first_project/word.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbContext {
  static late Isar isar;

  // Initialize
  static Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([DbWordSchema], directory: appDir.path);
  }

  Future<int> addWordAsync(Word word) async {
    final newWord = DbWord();
    newWord.dutchWord = word.dutchWord;
    newWord.englishWord = word.englishWord;
    newWord.type = word.type;
    newWord.deHet = word.deHet;
    newWord.pluralForm = word.pluralForm;
    newWord.tag = word.tag;

    final int id = await isar.writeTxn(() => isar.dbWords.put(newWord));

    return id;
  }

  Future<List<Word>> getWordsAsync() async {
    List<DbWord> dbWords = await isar.dbWords.where().findAll();
    List<Word> words = dbWords
        .map((dbWord) => Word(
              dbWord.dutchWord,
              dbWord.englishWord,
              dbWord.type,
              deHet: dbWord.deHet,
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
      dbWord.dutchWord,
      dbWord.englishWord,
      dbWord.type,
      deHet: dbWord.deHet,
      pluralForm: dbWord.pluralForm,
      tag: dbWord.tag,
    );
  }

  Future<void> deleteAsync(int id) async {
    await isar.writeTxn(() => isar.dbWords.delete(id));
  }
}
