import 'package:dutch_app/core/assets/models/word_audio_asset.dart';
import 'package:dutch_app/core/local_db/entities/db_word_audio.dart';

class WordAudioMapper {
  static DbWordAudio mapToEntity(WordAudioAsset asset) {
    var dbWord = DbWordAudio();
    dbWord.code = asset.code;
    dbWord.word = asset.word;
    return dbWord;
  }

  static List<DbWordAudio> mapToEntityList(List<WordAudioAsset> assets) {
    return assets.map((asset) => mapToEntity(asset)).toList();
  }
}
