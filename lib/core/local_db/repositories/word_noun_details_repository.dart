import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/base_word.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:isar/isar.dart';

class WordNounDetailsRepository {
  final DutchWordsRepository dutchWordsRepository;
  WordNounDetailsRepository(this.dutchWordsRepository);

  Future<void> maybeCreateNounDetailsAsync(BaseWord word, DbWord dbWord) async {
    if (word.partOfSpeech != PartOfSpeech.noun) {
      return;
    }

    final nounDetails = DbWordNounDetails();
    nounDetails.wordLink.value = dbWord;

    await _populateNounDetailsFromWord(word, nounDetails);

    await DbContext.isar.dbWordNounDetails.put(nounDetails);
    await nounDetails.wordLink.save();
    await nounDetails.pluralFormWordLink.save();
    await nounDetails.diminutiveWordLink.save();

    dbWord.nounDetailsLink.value = nounDetails;
    await dbWord.nounDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> upsertNounDetailsAsync(Word word, DbWord dbWord) async {
    var details = dbWord.nounDetailsLink.value;

    if (word.partOfSpeech != PartOfSpeech.noun) {
      if (details == null) return;
      await _removeDetailsFromWord(details, dbWord);
      return;
    }

    if (details == null) {
      details = DbWordNounDetails();
      details.wordLink.value = dbWord;
      dbWord.nounDetailsLink.value = details;
    }

    await _populateNounDetailsFromWord(word, details);

    await DbContext.isar.dbWordNounDetails.put(details);
    await details.wordLink.save();
    await details.pluralFormWordLink.save();
    await details.diminutiveWordLink.save();

    await dbWord.nounDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> _removeDetailsFromWord(
      DbWordNounDetails details, DbWord dbWord) async {
    await DbContext.isar.dbWordNounDetails.delete(details.id!);
    dbWord.nounDetailsLink.value = null;
    await dbWord.nounDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> _populateNounDetailsFromWord(
    BaseWord word,
    DbWordNounDetails details,
  ) async {
    details.deHet = word.deHetType;

    await _setOrClearPluralForm(word, details);
  }

  Future<void> _setOrClearPluralForm(
      BaseWord word, DbWordNounDetails details) async {
    if (word.pluralForm != null) {
      final plural = await dutchWordsRepository
          .getOrCreateRawAsync(word.pluralForm!.toLowerCase().trim());
      details.pluralFormWordLink.value = plural;
    } else {
      details.pluralFormWordLink.value = null;
    }
  }

  Future<void> setDiminutive(
      BaseWord word, DbWordNounDetails nounDetails) async {}

  Future<void> loadNounDetailsLinks(IsarLink<DbWordNounDetails>? link) async {
    await link?.load();
    await link?.value?.pluralFormWordLink.load();
    await link?.value?.diminutiveWordLink.load();
  }
}
