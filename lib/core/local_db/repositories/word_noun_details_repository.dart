import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/base_word.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
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

    await _populateNounDetailsFromWord(word.nounDetails, nounDetails);

    await DbContext.isar.dbWordNounDetails.put(nounDetails);
    await nounDetails.wordLink.save();
    await nounDetails.pluralFormWordLink.save();
    await nounDetails.diminutiveWordLink.save();

    dbWord.nounDetailsLink.value = nounDetails;
    await dbWord.nounDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> upsertNounDetailsAsync(Word word, DbWord dbWord) async {
    DbWordNounDetails? nounDetails = dbWord.nounDetailsLink.value;

    if (word.partOfSpeech != PartOfSpeech.noun) {
      if (nounDetails == null) return;
      await _removeDetailsFromWord(nounDetails, dbWord);
      return;
    }

    if (nounDetails == null) {
      nounDetails = DbWordNounDetails();
      nounDetails.wordLink.value = dbWord;
      dbWord.nounDetailsLink.value = nounDetails;
    }

    await _populateNounDetailsFromWord(word.nounDetails, nounDetails);

    await DbContext.isar.dbWordNounDetails.put(nounDetails);
    await nounDetails.wordLink.save();
    await nounDetails.pluralFormWordLink.save();
    await nounDetails.diminutiveWordLink.save();

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
    WordNounDetails? nounDetails,
    DbWordNounDetails dbNounDetails,
  ) async {
    if (nounDetails == null) return;
    dbNounDetails.deHet = nounDetails.deHetType;

    await _setOrClearPluralForm(nounDetails.pluralForm, dbNounDetails);
    await _setOrClearDiminutive(nounDetails.diminutive, dbNounDetails);
  }

  Future<void> _setOrClearPluralForm(
      String? value, DbWordNounDetails dbDetails) async {
    if (value != null) {
      final resultDutchWord = await dutchWordsRepository
          .getOrCreateRawAsync(value.toLowerCase().trim());
      dbDetails.pluralFormWordLink.value = resultDutchWord;
    } else {
      dbDetails.pluralFormWordLink.value = null;
    }
  }

  Future<void> _setOrClearDiminutive(
      String? value, DbWordNounDetails dbDetails) async {
    if (value != null) {
      final resultDutchWord = await dutchWordsRepository
          .getOrCreateRawAsync(value.toLowerCase().trim());
      dbDetails.pluralFormWordLink.value = resultDutchWord;
    } else {
      dbDetails.pluralFormWordLink.value = null;
    }
  }

  Future<void> loadNounDetailsLinks(IsarLink<DbWordNounDetails>? link) async {
    await link?.load();
    await link?.value?.pluralFormWordLink.load();
    await link?.value?.diminutiveWordLink.load();
  }
}
