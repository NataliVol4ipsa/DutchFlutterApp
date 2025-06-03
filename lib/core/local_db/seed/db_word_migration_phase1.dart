import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

class DbWordMigrationPhase1 {
  static Future<void> runAsync() async {
    final isar = DbContext.isar;

    List<DbWord> dbWords =
        await isar.dbWords.filter().pluralFormIsNotNull().findAll();

    final distinctDutchWords = dbWords
        .map((w) => w.pluralForm!.toLowerCase().trim())
        .where((w) => w != "")
        .toSet()
        .toList();

    await seedDutchWordsAsync(isar, distinctDutchWords);
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
}
