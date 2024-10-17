import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/core/models/word.dart';

class WordsRepository {
  final DbContext dbContext;

  WordsRepository({required this.dbContext});

  Future<int> addWordAsync(Word word) async {
    return await dbContext.addWordAsync(word);
  }

  Future<List<Word>> fetchWordsAsync() async {
    return await dbContext.getWordsAsync();
  }

  Future<void> deleteWordsAsync(List<int> wordIds) async {
    await dbContext.deleteBatchAsync(wordIds);
  }

  Future<bool> updateWordAsync(Word updatedWord) async {
    return await dbContext.updateWordAsync(updatedWord);
  }
}
