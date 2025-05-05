import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/core/local_db/seed/db_dutch_words_seed.dart';

Future<void> seedDatabaseAsync() async {
  await DbDefaultCollectionSeed.seedAsync();
  await DbDutchWordsSeed.seedAsync();
}
