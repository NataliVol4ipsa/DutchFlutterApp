import 'package:first_project/core/dtos/words_collection_dto_v1.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/mapping/words_io_mapper.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';

class WordsStorageService {
  final WordsRepository wordsRepository;

  WordsStorageService({required this.wordsRepository});

  Future<List<int>> storeInDatabaseAsync(
      WordsCollectionDtoV1 collection) async {
    List<Word> wordList = WordsIoMapper().toWordsListV1(collection);
    var result = await wordsRepository.addBatchAsync(wordList);

    return result;
  }
}
