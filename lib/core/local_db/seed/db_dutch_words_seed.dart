import 'package:dutch_app/core/assets/words_audio_reader.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/mapping/dutch_word_mapper.dart';
import 'package:isar/isar.dart';

class DbDutchWordsSeed {
  static Future<void> seedAsync() async {
    var isar = DbContext.isar;

    final hasAny = await isar.dbDutchWords.where().limit(1).findFirst() != null;
    if (hasAny) {
      return;
    }

    final assets = await WordsAudioReader().readCsvFile();
    final newItems = DutchWordMapper.mapToEntityList(assets);

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbDutchWords.putAll(newItems));
  }
}
