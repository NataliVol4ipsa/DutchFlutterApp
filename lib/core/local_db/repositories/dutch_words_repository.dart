import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/mapping/dutch_word_mapper.dart';
import 'package:dutch_app/domain/models/dutch_word.dart';
import 'package:isar/isar.dart';

class DutchWordsRepository {
  // Future<List<int>> addBatchAsync(List<DutchWordAsset> words) async {
  //   final newWords = DutchWordMapper.mapToEntityList(words);

  //   final List<int> ids = await DbContext.isar
  //       .writeTxn(() => DbContext.isar.dbDutchWords.putAll(newWords));

  //   return ids;
  // }

  Future<List<DutchWord>> getBatchAsync(List<String> words) async {
    final audios = await Future.wait(words.map((word) {
      return DbContext.isar.dbDutchWords.where().wordEqualTo(word).findFirst();
    }));

    final dbAudios = audios.whereType<DbDutchWord>().toList();
    List<DutchWord> wordAudios = DutchWordMapper.mapToDomainList(dbAudios);

    return wordAudios;
  }

  Future<DbDutchWord> getOrCreateRawAsync(String dutchWord) async {
    var existingWord = await _getRawAsync(dutchWord);
    if (existingWord != null) {
      return existingWord;
    }

    return await _createRawAsync(dutchWord);
  }

  Future<DbDutchWord> _createRawAsync(String newDutchWord) async {
    var entity = DbDutchWord()
      ..word = newDutchWord
      ..audioCode = null;

    await DbContext.isar.dbDutchWords.put(entity);

    return entity;
  }

  Future<DbDutchWord?> _getRawAsync(String dutchWord) async {
    dutchWord = dutchWord.toLowerCase().trim();
    final isInfinitive = dutchWord.startsWith('to ');
    dutchWord = isInfinitive ? dutchWord.substring(3).trim() : dutchWord;

    final dbDutchWord = await DbContext.isar.dbDutchWords
        .where()
        .wordEqualTo(dutchWord)
        .findFirst();

    return dbDutchWord;
  }
}
