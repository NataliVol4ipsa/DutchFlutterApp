import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/local_db/repositories/settings_repository.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';
import 'package:provider/provider.dart';

List<Provider> databaseProviders() {
  return [
    Provider<DbContext>(create: (_) => DbContext()),
    Provider<WordsRepository>(create: (_) => WordsRepository()),
    Provider<BatchRepository>(create: (_) => BatchRepository()),
    Provider<WordCollectionsRepository>(
        create: (_) => WordCollectionsRepository()),
    Provider<WordProgressRepository>(create: (_) => WordProgressRepository()),
    Provider<SettingsRepository>(create: (_) => SettingsRepository()),
  ];
}
