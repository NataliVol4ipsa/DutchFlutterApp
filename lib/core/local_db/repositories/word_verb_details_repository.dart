import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';

class WordVerbDetailsRepository {
  final DutchWordsRepository dutchWordsRepository;
  WordVerbDetailsRepository(this.dutchWordsRepository);

  Future<void> maybeCreateVerbDetailsAsync(NewWord word, DbWord dbWord) async {}
}
