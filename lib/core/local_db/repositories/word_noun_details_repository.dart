import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

class WordNounDetailsRepository {
  final DutchWordsRepository dutchWordsRepository;
  WordNounDetailsRepository(this.dutchWordsRepository);

  Future<void> maybeCreateNounDetailsAsync(NewWord word, DbWord dbWord) async {
    final nounDetails = DbWordNounDetails();
    nounDetails.deHet = dbWord.deHet;
    nounDetails.wordLink.value = dbWord;

    await setPluralForm(word, nounDetails);
    await setDiminutive(word, nounDetails);

    await DbContext.isar.dbWordNounDetails.put(nounDetails);
    await nounDetails.wordLink.save();
    await nounDetails.pluralFormWordLink.save();
    await nounDetails.diminutiveWordLink.save();

    dbWord.nounDetailsLink.value = nounDetails;
    await dbWord.nounDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> setPluralForm(
      NewWord word, DbWordNounDetails nounDetails) async {
    if (word.pluralForm != null) {
      final plural = await dutchWordsRepository
          .getOrCreateRawAsync(word.pluralForm!.toLowerCase().trim());
      nounDetails.pluralFormWordLink.value = plural;
    }
  }

  Future<void> setDiminutive(
      NewWord word, DbWordNounDetails nounDetails) async {
    // if (word.diminutive != null) {
    //   final diminutive = await dutchWordsRepository
    //       .getOrCreateRawAsync(word.diminutive!.toLowerCase().trim());
    //   nounDetails.diminutiveWordLink.value = diminutive;
    // }
  }

  Future<void> loadNounDetailsLinks(IsarLink<DbWordNounDetails>? link) async {
    await link?.load();
    await link?.value?.pluralFormWordLink.load();
    await link?.value?.diminutiveWordLink.load();
  }
}
