import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/io/v1/mapping/words_io_mapper.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';

class WordsStorageService {
  final WordsRepository wordsRepository;

  WordsStorageService({required this.wordsRepository});

  Future<List<int>> storeInDatabaseAsync(ExportPackageV1 package) async {
    throw Exception("not implemented");
    // List<NewWord> wordList = WordsIoMapper().toNewWordsListV1(package);
    // var result = await wordsRepository.addBatchAsync(wordList);

    //return result;
  }
}
