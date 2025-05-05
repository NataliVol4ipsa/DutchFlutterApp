import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:isar/isar.dart';

class EnglishWordsRepository {
  Future<List<DbEnglishWord>> getOrCreateRawListAsync(
      List<String> englishWords) async {
    return await Future.wait(
      englishWords.map(
        (word) => _getOrCreateRawAsync(word),
      ),
    );
  }

  Future<DbEnglishWord> _createRawAsync(String newEnglishWord) async {
    var entity = DbEnglishWord()..word = newEnglishWord;

    await DbContext.isar.dbEnglishWords.put(entity);

    return entity;
  }

  Future<DbEnglishWord?> _getRawAsync(String englishWord) async {
    englishWord = englishWord.toLowerCase().trim();
    final isInfinitive = englishWord.startsWith('to ');
    englishWord = isInfinitive ? englishWord.substring(3).trim() : englishWord;

    final dbEnglishWord = await DbContext.isar.dbEnglishWords
        .where()
        .wordEqualTo(englishWord)
        .findFirst();

    return dbEnglishWord;
  }

  Future<DbEnglishWord> _getOrCreateRawAsync(String englishWord) async {
    var existingWord = await _getRawAsync(englishWord);
    if (existingWord != null) {
      return existingWord;
    }

    return await _createRawAsync(englishWord);
  }
}
