import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_details.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:isar/isar.dart';

class WordVerbDetailsRepository {
  final DutchWordsRepository dutchWordsRepository;
  WordVerbDetailsRepository(this.dutchWordsRepository);

  Future<void> maybeCreateVerbDetailsAsync(NewWord word, DbWord dbWord) async {
    if (word.verbDetails == null) return;

    final verbDetails = DbWordVerbDetails();
    verbDetails.wordLink.value = dbWord;

    await _populateVerbDetailsFromWord(word.verbDetails!, verbDetails);

    await DbContext.isar.dbWordVerbDetails.put(verbDetails);
    await _saveAllLinks(verbDetails);

    dbWord.verbDetailsLink.value = verbDetails;
    await dbWord.verbDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> upsertVerbDetailsAsync(Word word, DbWord dbWord) async {
    DbWordVerbDetails? verbDetails = dbWord.verbDetailsLink.value;

    if (word.verbDetails == null) {
      if (verbDetails == null) return;
      await _removeDetailsFromWord(verbDetails, dbWord);
      return;
    }

    if (verbDetails == null) {
      verbDetails = DbWordVerbDetails();
      verbDetails.wordLink.value = dbWord;
      dbWord.verbDetailsLink.value = verbDetails;
    }

    await _populateVerbDetailsFromWord(word.verbDetails!, verbDetails);

    await DbContext.isar.dbWordVerbDetails.put(verbDetails);
    await _saveAllLinks(verbDetails);

    await dbWord.verbDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> _removeDetailsFromWord(
      DbWordVerbDetails details, DbWord dbWord) async {
    await DbContext.isar.dbWordVerbDetails.delete(details.id!);
    dbWord.verbDetailsLink.value = null;
    await dbWord.verbDetailsLink.save();
    await DbContext.isar.dbWords.put(dbWord);
  }

  Future<void> _populateVerbDetailsFromWord(
      WordVerbDetails word, DbWordVerbDetails db) async {
    await _set(db.infinitiveWordLink, word.infinitive);
    await _set(db.completedParticipleWordLink, word.completedParticiple);
    await _set(db.auxiliaryVerbWordLink, word.auxiliaryVerb);

    await _set(db.imperativeInformalWordLink, word.imperative.informal);
    await _set(db.imperativeFormalWordLink, word.imperative.formal);

    await _set(db.presentParticipleInflectedWordLink,
        word.presentParticiple.inflected);
    await _set(db.presentParticipleUninflectedWordLink,
        word.presentParticiple.uninflected);

    await _set(db.presentTenseIkWordLink, word.presentTense.ik);
    await _set(db.presentTenseJijVraagWordLink, word.presentTense.jijVraag);
    await _set(db.presentTenseJijWordLink, word.presentTense.jij);
    await _set(db.presentTenseUWordLink, word.presentTense.u);
    await _set(db.presentTenseHijZijHetWordLink, word.presentTense.hijZijHet);
    await _set(db.presentTenseWijWordLink, word.presentTense.wij);
    await _set(db.presentTenseJullieWordLink, word.presentTense.jullie);
    await _set(db.presentTenseZijWordLink, word.presentTense.zij);

    await _set(db.pastTenseIkWordLink, word.pastTense.ik);
    await _set(db.pastTenseJijWordLink, word.pastTense.jij);
    await _set(db.pastTenseHijZijHetWordLink, word.pastTense.hijZijHet);
    await _set(db.pastTenseWijWordLink, word.pastTense.wij);
    await _set(db.pastTenseJullieWordLink, word.pastTense.jullie);
    await _set(db.pastTenseZijWordLink, word.pastTense.zij);
  }

  Future<void> _set(IsarLink<DbDutchWord> link, String? value) async {
    if (value != null) {
      link.value = await dutchWordsRepository
          .getOrCreateRawAsync(value.toLowerCase().trim());
    } else {
      link.value = null;
    }
  }

  Future<void> _saveAllLinks(DbWordVerbDetails d) async {
    await Future.wait([
      d.wordLink.save(),
      d.infinitiveWordLink.save(),
      d.completedParticipleWordLink.save(),
      d.auxiliaryVerbWordLink.save(),
      d.imperativeInformalWordLink.save(),
      d.imperativeFormalWordLink.save(),
      d.presentParticipleInflectedWordLink.save(),
      d.presentParticipleUninflectedWordLink.save(),
      d.presentTenseIkWordLink.save(),
      d.presentTenseJijVraagWordLink.save(),
      d.presentTenseJijWordLink.save(),
      d.presentTenseUWordLink.save(),
      d.presentTenseHijZijHetWordLink.save(),
      d.presentTenseWijWordLink.save(),
      d.presentTenseJullieWordLink.save(),
      d.presentTenseZijWordLink.save(),
      d.pastTenseIkWordLink.save(),
      d.pastTenseJijWordLink.save(),
      d.pastTenseHijZijHetWordLink.save(),
      d.pastTenseWijWordLink.save(),
      d.pastTenseJullieWordLink.save(),
      d.pastTenseZijWordLink.save(),
    ]);
  }

  Future<void> loadVerbDetailsLinks(IsarLink<DbWordVerbDetails>? link) async {
    await link?.load();
    final details = link?.value;
    if (details == null) return;

    await Future.wait([
      details.infinitiveWordLink.load(),
      details.completedParticipleWordLink.load(),
      details.auxiliaryVerbWordLink.load(),
      details.imperativeInformalWordLink.load(),
      details.imperativeFormalWordLink.load(),
      details.presentParticipleInflectedWordLink.load(),
      details.presentParticipleUninflectedWordLink.load(),
      details.presentTenseIkWordLink.load(),
      details.presentTenseJijVraagWordLink.load(),
      details.presentTenseJijWordLink.load(),
      details.presentTenseUWordLink.load(),
      details.presentTenseHijZijHetWordLink.load(),
      details.presentTenseWijWordLink.load(),
      details.presentTenseJullieWordLink.load(),
      details.presentTenseZijWordLink.load(),
      details.pastTenseIkWordLink.load(),
      details.pastTenseJijWordLink.load(),
      details.pastTenseHijZijHetWordLink.load(),
      details.pastTenseWijWordLink.load(),
      details.pastTenseJullieWordLink.load(),
      details.pastTenseZijWordLink.load(),
    ]);
  }
}
