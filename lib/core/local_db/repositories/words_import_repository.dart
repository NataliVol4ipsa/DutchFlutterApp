import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_noun_details_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_verb_details_repository.dart';
import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/mapping/word_collections_mapper.dart';
import 'package:dutch_app/core/local_db/mapping/words_mapper.dart';

class WordsImportRepository {
  final DutchWordsRepository dutchWordsRepository;
  final EnglishWordsRepository englishWordsRepository;
  final WordNounDetailsRepository nounDetailsRepository;
  final WordVerbDetailsRepository verbDetailsRepository;

  WordsImportRepository(
    this.englishWordsRepository,
    this.dutchWordsRepository,
    this.nounDetailsRepository,
    this.verbDetailsRepository,
  );

  Future<void> importAsync(
    List<NewWordCollection> newCollections, {
    void Function(int processed, int total)? onProgress,
  }) async {
    final totalWords = newCollections.fold(0, (s, c) => s + c.words.length);

    final allDutchWords = newCollections
        .expand((c) => c.words.map((w) => w.dutchWord.toLowerCase().trim()))
        .toSet()
        .toList();
    final allEnglishWords = newCollections
        .expand(
          (c) => c.words.expand(
            (w) => w.englishWords.map((e) => e.toLowerCase().trim()),
          ),
        )
        .toSet()
        .toList();

    final dutchMap = await DbContext.isar.writeTxn(() async {
      final entities = await dutchWordsRepository.getOrCreateRawListAsync(
        allDutchWords,
      );
      return {
        for (var i = 0; i < allDutchWords.length; i++)
          allDutchWords[i]: entities[i],
      };
    });

    final englishMap = await DbContext.isar.writeTxn(() async {
      final entities = await englishWordsRepository.getOrCreateRawListAsync(
        allEnglishWords,
      );
      return {
        for (var i = 0; i < allEnglishWords.length; i++)
          allEnglishWords[i]: entities[i],
      };
    });

    int processed = 0;
    await DbContext.isar.writeTxn(() async {
      for (final collection in newCollections) {
        final isDefault = CollectionPermissionService.isDefaultCollectionName(
          collection.name,
        );

        late DbWordCollection dbCol;
        if (isDefault) {
          final existing = await DbContext.isar.dbWordCollections.get(
            CollectionPermissionService.defaultCollectionId,
          );
          if (existing == null) throw Exception('Default collection not found');
          dbCol = existing;
        } else {
          dbCol = WordCollectionsMapper.mapToEntity(collection);
          await DbContext.isar.dbWordCollections.put(dbCol);
        }
        await dbCol.words.load();

        for (final word in collection.words) {
          final dbWord = WordsMapper.mapToEntity(word);
          await DbContext.isar.dbWords.put(dbWord);

          final dutchKey = word.dutchWord.toLowerCase().trim();
          final dutchWordLink = dutchMap[dutchKey];
          if (dutchWordLink == null) {
            throw Exception('No dutch word record for "$dutchKey"');
          }
          dutchWordLink.words.add(dbWord);
          await dutchWordLink.words.save();

          dbWord.englishWordLinks.reset();
          dbWord.englishWordLinks.addAll(
            word.englishWords
                .map((e) => englishMap[e.toLowerCase().trim()])
                .whereType<DbEnglishWord>(),
          );
          await dbWord.englishWordLinks.save();

          await nounDetailsRepository.maybeCreateNounDetailsAsync(word, dbWord);
          await verbDetailsRepository.maybeCreateVerbDetailsAsync(word, dbWord);

          dbCol.words.add(dbWord);

          processed++;
          onProgress?.call(processed, totalWords);
        }

        dbCol.lastUpdated = DateTime.now();
        await dbCol.words.save();
        await DbContext.isar.dbWordCollections.put(dbCol);
      }
    });
  }
}
