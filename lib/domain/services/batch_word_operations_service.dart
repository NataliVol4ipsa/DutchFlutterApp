import 'package:dutch_app/core/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_import_repository.dart';
import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/core/io/v1/mapping/words_io_mapper.dart';
import 'package:dutch_app/core/io/v1/models/export_package_v1.dart';

class BatchWordOperationsService {
  final WordsImportRepository importRepository;
  final BatchRepository batchRepository;

  BatchWordOperationsService(
      {required this.batchRepository, required this.importRepository});

//todo progress bar for import
//todo logs
//todo track files and do not import them twice? hash?
  Future<void> storeInDatabaseAsync(ExportPackageV1 package) async {
    List<NewWordCollection> newCollections =
        WordsIoMapper.toNewCollectionList(package);

    await importRepository.importAsync(newCollections);
  }

  Future<void> deleteAsync(
      {required List<int> wordIds, required List<int> collectionIds}) async {
    await batchRepository.deleteAsync(wordIds, collectionIds);
  }
}
