import 'package:dutch_app/core/models/new_word_collection.dart';
import 'package:dutch_app/io/v1/mapping/words_io_mapper.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';
import 'package:dutch_app/local_db/repositories/word_collections_repository.dart';
import 'package:dutch_app/local_db/repositories/words_repository.dart';

class WordsStorageService {
  final WordsRepository wordsRepository;
  final WordCollectionsRepository collectionsRepository;

  WordsStorageService(
      {required this.wordsRepository, required this.collectionsRepository});

//todo progress bar for import
//todo logs
//todo track files and do not import them twice? hash?
  Future<void> storeInDatabaseAsync(ExportPackageV1 package) async {
    List<NewWordCollection> newCollections =
        WordsIoMapper.toNewCollectionList(package);

    for (int i = 0; i < newCollections.length; i++) {
      int dbCollectionId =
          await collectionsRepository.addAsync(newCollections[i]);
      await wordsRepository.addNewWordsAndCollectionsAsync(
          dbCollectionId, newCollections[i].words);
    }
  }
}
