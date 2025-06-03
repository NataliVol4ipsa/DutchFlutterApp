import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:isar/isar.dart';

class WordVerbDetailsRepository {
  final DutchWordsRepository dutchWordsRepository;
  WordVerbDetailsRepository(this.dutchWordsRepository);

  Future<void> maybeCreateVerbDetailsAsync(NewWord word, DbWord dbWord) async {}

  Future<void> upsertNounDetailsAsync(Word word, DbWord dbWord) async {}

  Future<void> loadVerbDetailsLinks(IsarLink<DbWordVerbDetails>? link) async {
    await link?.load();
  }
}
