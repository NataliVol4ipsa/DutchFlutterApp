import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:isar/isar.dart';

class DbWordMigrationPhase2 {
  static Future<void> runAsync() async {
    final isar = DbContext.isar;
    final alreadyComplete =
        await isar.dbWordNounDetails.where().limit(1).findFirst() != null;
    if (alreadyComplete) {
      return;
    }

    final words = await isar.dbWords.filter().pluralFormIsNotNull().findAll();

    // Pre-load Dutch plural word matches
    final Map<String, DbDutchWord> pluralWordMap = {
      for (final dw in await isar.dbDutchWords.where().findAll())
        dw.word.toLowerCase().trim(): dw
    };

    final List<DbWord> updatedWords = [];
    final List<DbWordNounDetails> newNounDetails = [];

    for (final word in words) {
      final pluralKey = word.pluralForm!.toLowerCase().trim();
      final pluralDutchWord = pluralWordMap[pluralKey];

      if (pluralDutchWord == null) continue;

      final nounDetails = DbWordNounDetails();
      nounDetails.deHet = word.deHet;
      nounDetails.pluralFormWordLink.value = pluralDutchWord;
      nounDetails.wordLink.value = word;

      word.nounDetailsLink.value = nounDetails;

      updatedWords.add(word);
      newNounDetails.add(nounDetails);
    }

    await isar.writeTxn(() async {
      await isar.dbWordNounDetails
          .putAll(newNounDetails); // insert noun details first
      await isar.dbWords.putAll(updatedWords); // update word links

      for (final details in newNounDetails) {
        await details.pluralFormWordLink.save();
        await details.wordLink.save();
      }
      for (final word in updatedWords) {
        await word.nounDetailsLink.save();
      }
    });
  }
}
