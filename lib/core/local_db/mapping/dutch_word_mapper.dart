import 'package:dutch_app/core/assets/models/dutch_word_asset.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/domain/models/dutch_word.dart';

class DutchWordMapper {
  static DbDutchWord mapToEntity(DutchWordAsset asset) {
    var dbWord = DbDutchWord();
    dbWord.audioCode = asset.audioCode;
    dbWord.word = asset.word.toLowerCase();
    return dbWord;
  }

  static List<DbDutchWord> mapToEntityList(List<DutchWordAsset> assets) {
    return assets.map((asset) => mapToEntity(asset)).toList();
  }

  static DutchWord mapToDomain(DbDutchWord dbWordAudio) {
    var dbWord = DutchWord(dbWordAudio.word.toLowerCase());
    dbWord.id = dbWordAudio.id;
    dbWord.audioCode = dbWordAudio.audioCode;
    return dbWord;
  }

  static List<DutchWord> mapToDomainList(List<DbDutchWord> dbWordAudios) {
    return dbWordAudios.map((asset) => mapToDomain(asset)).toList();
  }
}
