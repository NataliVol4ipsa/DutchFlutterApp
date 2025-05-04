import 'package:dutch_app/core/assets/words_audio_reader.dart';
import 'package:dutch_app/core/local_db/entities/db_word_audio.dart';
import 'package:dutch_app/core/local_db/mapping/word_audio_mapper.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:isar/isar.dart';

class DbWordsAudioSeed {
  static Future<void> seedAsync() async {
    var isar = DbContext.isar;

    final hasAny = await isar.dbWordAudios.where().limit(1).findFirst() != null;
    if (hasAny) {
      return;
    }

    final assets = await WordsAudioReader().readCsvFile();
    final newItems = WordAudioMapper.mapToEntityList(assets);

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordAudios.putAll(newItems));
  }
}
