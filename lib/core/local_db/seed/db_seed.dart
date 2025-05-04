import 'package:dutch_app/core/local_db/seed/db_default_collection_seed.dart';
import 'package:dutch_app/core/local_db/seed/db_words_audio_seed.dart';

Future<void> seedDatabaseAsync() async {
  await DbDefaultCollectionSeed.seedAsync();
  await DbWordsAudioSeed.seedAsync();
}
