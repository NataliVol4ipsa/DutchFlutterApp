import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/settings_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_import_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:provider/provider.dart';

List<Provider> databaseProviders() {
  return [
    Provider<DbContext>(create: (_) => DbContext()),
    Provider<DutchWordsRepository>(create: (_) => DutchWordsRepository()),
    Provider<EnglishWordsRepository>(create: (_) => EnglishWordsRepository()),
    Provider<BatchRepository>(create: (_) => BatchRepository()),
    Provider<WordsImportRepository>(create: (_) => WordsImportRepository()),
    Provider<WordCollectionsRepository>(
        create: (_) => WordCollectionsRepository()),
    Provider<WordProgressRepository>(create: (_) => WordProgressRepository()),
    Provider<SettingsRepository>(create: (_) => SettingsRepository()),
    Provider<WordsRepository>(
        create: (context) => WordsRepository(
            context.read<EnglishWordsRepository>(),
            context.read<DutchWordsRepository>())),
  ];
}
