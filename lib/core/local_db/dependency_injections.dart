import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/settings_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository_v2.dart';
import 'package:provider/provider.dart';

List<Provider> databaseProviders() {
  return [
    Provider<DbContext>(create: (_) => DbContext()),
    Provider<WordsRepositoryV2>(
        create: (_) => WordsRepositoryV2(
            EnglishWordsRepository(), DutchWordsRepository())),
    Provider<BatchRepository>(create: (_) => BatchRepository()),
    Provider<WordCollectionsRepository>(
        create: (_) => WordCollectionsRepository()),
    Provider<WordProgressRepository>(create: (_) => WordProgressRepository()),
    Provider<SettingsRepository>(create: (_) => SettingsRepository()),
    Provider<DutchWordsRepository>(create: (_) => DutchWordsRepository()),
    Provider<EnglishWordsRepository>(create: (_) => EnglishWordsRepository()),
  ];
}
