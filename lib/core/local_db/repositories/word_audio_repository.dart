import 'package:dutch_app/core/assets/models/word_audio_asset.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word_audio.dart';
import 'package:dutch_app/core/local_db/mapping/word_audio_mapper.dart';

class WordAudioRepository {
  Future<List<int>> addBatchAsync(List<WordAudioAsset> words) async {
    final newWords = WordAudioMapper.mapToEntityList(words);

    final List<int> ids = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordAudios.putAll(newWords));

    return ids;
  }
}
