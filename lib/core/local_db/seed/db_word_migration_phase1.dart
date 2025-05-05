import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

class DbWordMigrationPhase1 {
  static Future<void> runAsync() async {
    final isar = DbContext.isar;

    final alreadyComplete =
        await isar.dbEnglishWords.where().limit(1).findFirst() != null;
    if (alreadyComplete) {
      return;
    }

    List<DbWord> dbWords = await DbContext.isar.dbWords.where().findAll();
    final distinctDutchWords =
        dbWords.map((w) => w.dutchWord.toLowerCase().trim()).toSet().toList();
    final distinctEnglishWords = dbWords
        .expand((w) => w.englishWord
            .split(';')
            .map((word) => cleanEnglishWord(word.trim().toLowerCase())))
        .toSet()
        .toList();

    await seedDutchWordsAsync(isar, distinctDutchWords);
    await seedEnglishWordsAsync(isar, distinctEnglishWords);
  }

  static String cleanEnglishWord(String word) {
    final isInfinitive = word.startsWith('to ');
    final cleanedWord = isInfinitive ? word.substring(3).trim() : word;
    return cleanedWord;
  }

  static Future<void> seedDutchWordsAsync(
      Isar isar, List<String> distinctDutchWords) async {
    // Query all existing words in parallel
    final existingWordEntries = await Future.wait(
      distinctDutchWords.map(
        (word) => isar.dbDutchWords.where().wordEqualTo(word).findFirst(),
      ),
    );

    // Filter the words that are missing (i.e., where findFirst() returned null)
    final wordsToCreate = <String>[];
    for (int i = 0; i < distinctDutchWords.length; i++) {
      if (existingWordEntries[i] == null) {
        wordsToCreate.add(distinctDutchWords[i]);
      }
    }

    // Insert them into DB
    if (wordsToCreate.isNotEmpty) {
      final newWords = wordsToCreate.map((word) {
        var result = DbDutchWord();
        result.word = word;
        result.audioCode = null;
        return result;
      }).toList();
      await isar.writeTxn(() => isar.dbDutchWords.putAll(newWords));
    }
  }

  static Future<void> seedEnglishWordsAsync(
      Isar isar, List<String> distinctEnglishWords) async {
    final newWords = distinctEnglishWords
        .map((word) => DbEnglishWord()..word = word)
        .toList();

    await isar.writeTxn(() => isar.dbEnglishWords.putAll(newWords));
  }
}
