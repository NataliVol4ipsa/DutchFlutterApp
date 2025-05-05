import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/core/local_db/seed/db_dutch_words_seed.dart';
import 'package:dutch_app/core/local_db/seed/db_word_migration_phase1.dart';
import 'package:dutch_app/core/local_db/seed/db_word_migration_phase2.dart';

Future<void> seedDatabaseAsync() async {
  await DbDefaultCollectionSeed.seedAsync();
  await DbDutchWordsSeed.seedAsync();
  await DbWordMigrationPhase1.runAsync();
  await DbWordMigrationPhase2.runAsync();
}
