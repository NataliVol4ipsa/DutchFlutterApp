import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/mapping/word_collections_mapper.dart';
import 'package:dutch_app/core/local_db/mapping/words_mapper.dart';

class WordsImportRepository {
  Future<void> importAsync(List<NewWordCollection> newCollections) async {
    await DbContext.isar.writeTxn(() async {
      Map<String, DbDutchWord> duMaps =
          await _createDutchWordsMap(newCollections);
      Map<String, DbEnglishWord> enMaps =
          await _createEnglishWordsMap(newCollections);

      for (int i = 0; i < newCollections.length; i++) {
        if (CollectionPermissionService.isDefaultCollectionName(
            newCollections[i].name)) {
          await _importDefaultCollectionAsync(
              newCollections[i], enMaps, duMaps);
        } else {
          await _importCollectionAsync(newCollections[i], enMaps, duMaps);
        }
      }
    });
  }

  Future<Map<String, DbEnglishWord>> _createEnglishWordsMap(
      List<NewWordCollection> newCollections) async {
    var englishWords = newCollections
        .expand((col) => col.words.expand(
            (word) => word.englishWords.map((e) => e.toLowerCase().trim())))
        .toSet()
        .toList();
    var enRepo = EnglishWordsRepository();
    final enMaps = <String, DbEnglishWord>{};
    var enEntities = await enRepo.getOrCreateRawListAsync(englishWords);
    for (int i = 0; i < englishWords.length; i++) {
      enMaps[englishWords[i]] = enEntities[i];
    }
    return enMaps;
  }

  Future<Map<String, DbDutchWord>> _createDutchWordsMap(
      List<NewWordCollection> newCollections) async {
    var dutchWords = newCollections
        .expand((col) =>
            col.words.map((word) => word.dutchWord.toLowerCase().trim()))
        .toSet()
        .toList();
    var duRepo = DutchWordsRepository();
    final duMaps = <String, DbDutchWord>{};
    var duEntities = await duRepo.getOrCreateRawListAsync(dutchWords);
    for (int i = 0; i < dutchWords.length; i++) {
      duMaps[dutchWords[i]] = duEntities[i];
    }
    return duMaps;
  }

  Future<void> _importCollectionAsync(
      NewWordCollection wordCollection,
      Map<String, DbEnglishWord> enMaps,
      Map<String, DbDutchWord> duMaps) async {
    final newCollection = WordCollectionsMapper.mapToEntity(wordCollection);
    await DbContext.isar.dbWordCollections.put(newCollection);

    await _putWordsIntoCollection(
        wordCollection.words, newCollection, enMaps, duMaps);
  }

  Future<void> _importDefaultCollectionAsync(
      NewWordCollection wordCollection,
      Map<String, DbEnglishWord> enMaps,
      Map<String, DbDutchWord> duMaps) async {
    final defaultCollection = await DbContext.isar.dbWordCollections
        .get(CollectionPermissionService.defaultCollectionId);
    if (defaultCollection == null) {
      throw Exception("Could not find default collection");
    }

    await _putWordsIntoCollection(
        wordCollection.words, defaultCollection, enMaps, duMaps);
  }

  Future<void> _putWordsIntoCollection(
      List<NewWord> words,
      DbWordCollection collection,
      Map<String, DbEnglishWord> enMaps,
      Map<String, DbDutchWord> duMaps) async {
    final newWords =
        await Future.wait(words.map((word) => _putWord(word, enMaps, duMaps)));

    collection.words.addAll(newWords);
    collection.lastUpdated = DateTime.now();

    await collection.words.save();
    await DbContext.isar.dbWordCollections.put(collection);
  }

  Future<DbWord> _putWord(NewWord word, Map<String, DbEnglishWord> enMaps,
      Map<String, DbDutchWord> duMaps) async {
    final newWord = WordsMapper.mapToEntity(word);
    await DbContext.isar.dbWords.put(newWord);
    await _updateWordDutchLinkAsync(duMaps, newWord, word.dutchWord);
    await _updateWordEnglishLinksAsync(enMaps, newWord, word.englishWords);
    return newWord;
  }

  Future<void> _updateWordDutchLinkAsync(Map<String, DbDutchWord> duMaps,
      DbWord dbWord, String originalWord) async {
    final dutchWordLink = duMaps[originalWord];
    if (dutchWordLink == null) {
      throw Exception("inner exception. No dutch word in map");
    }
    dutchWordLink.words.add(dbWord);
    await dutchWordLink.words.save();
  }

  Future<void> _updateWordEnglishLinksAsync(Map<String, DbEnglishWord> enMaps,
      DbWord dbWord, List<String> originalWords) async {
    dbWord.englishWordLinks.reset();
    final englishWordLinks =
        originalWords.map((w) => enMaps[w]).whereType<DbEnglishWord>();
    dbWord.englishWordLinks.addAll(englishWordLinks);
    await dbWord.englishWordLinks.save();
  }
}
