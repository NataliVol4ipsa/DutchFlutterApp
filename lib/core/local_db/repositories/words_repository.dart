import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/repositories/dutch_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/english_words_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_noun_details_repository.dart';
import 'package:dutch_app/core/local_db/repositories/word_verb_details_repository.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/domain/services/collection_permission_service.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';

import '../mapping/words_mapper.dart';

class WordsRepository {
  final DutchWordsRepository dutchWordsRepository;
  final EnglishWordsRepository englishWordsRepository;
  final WordNounDetailsRepository nounDetailsRepository;
  final WordVerbDetailsRepository verbDetailsRepository;

  WordsRepository(this.englishWordsRepository, this.dutchWordsRepository,
      this.nounDetailsRepository, this.verbDetailsRepository);

  Future<int> addAsync(NewWord word) async {
    final newWord = WordsMapper.mapToEntity(word);
    int collectionId =
        word.collection?.id ?? CollectionPermissionService.defaultCollectionId;
    int newWordId = -1;

    await DbContext.isar.writeTxn(() async {
      final collection =
          await DbContext.isar.dbWordCollections.get(collectionId);
      if (collection != null) {
        newWordId =
            await _processAddAsync(newWordId, newWord, collection, word);
      } else {
        throw Exception("Could not find collection with id $collectionId");
      }
    });

    return newWordId;
  }

  Future<int> _processAddAsync(int newWordId, DbWord newWord,
      DbWordCollection collection, NewWord word) async {
    newWordId = await DbContext.isar.dbWords.put(newWord);

    collection.words.add(newWord);
    await collection.words.save();
    collection.lastUpdated = DateTime.now();
    await DbContext.isar.dbWordCollections.put(collection);

    await _updateWordDutchLinkAsync(word.dutchWord, newWord);
    await _updateWordEnglishLinksAsync(word.englishWords, newWord);

    await nounDetailsRepository.maybeCreateNounDetailsAsync(word, newWord);
    await verbDetailsRepository.maybeCreateVerbDetailsAsync(word, newWord);

    return newWordId;
  }

  Future<void> _updateWordDutchLinkAsync(
      String dutchWord, DbWord dbWord) async {
    final dutchWordLink =
        await dutchWordsRepository.getOrCreateRawAsync(dutchWord);
    dutchWordLink.words.add(dbWord);
    await dutchWordLink.words.save();
  }

  Future<void> _updateWordEnglishLinksAsync(
      List<String> englishWords, DbWord dbWord) async {
    dbWord.englishWordLinks.reset();

    final englishWordLinks =
        await englishWordsRepository.getOrCreateRawListAsync(englishWords);
    dbWord.englishWordLinks.addAll(englishWordLinks);
    await dbWord.englishWordLinks.save();
  }

  Future<DbWord?> _getWordWithWordLinksAsync(int wordId) async {
    final DbWord? dbWord = await DbContext.isar.dbWords.get(wordId);

    await dbWord?.collection.load();
    await dbWord?.dutchWordLink.load();
    await dbWord?.englishWordLinks.load();
    await nounDetailsRepository.loadNounDetailsLinks(dbWord?.nounDetailsLink);
    await verbDetailsRepository.loadVerbDetailsLinks(dbWord?.verbDetailsLink);

    return dbWord;
  }

  Future<Word?> getWordAsync(int wordId) async {
    final DbWord? dbWord = await _getWordWithWordLinksAsync(wordId);

    Word? word = WordsMapper.mapToDomain(dbWord);
    return word;
  }

  Future<bool> updateAsync(Word updatedWord) async {
    final DbWord? dbWord = await _getWordWithWordLinksAsync(updatedWord.id);

    if (dbWord == null) {
      throw Exception(
          "Tried to update word ${updatedWord.id}, but it was not found in database.");
    }
    bool isChangedDutchWord =
        dbWord.dutchWordLink.value?.word != updatedWord.dutchWord;

    await DbContext.isar.writeTxn(() async {
      // Main word update
      _mapUpdatedWordToEntity(dbWord, updatedWord);
      DbContext.isar.dbWords.put(dbWord);

      // Process changed dutch word
      if (isChangedDutchWord) {
        await _removeWordFromDutchWordsLinksAsync(
            dbWord, dbWord.dutchWordLink.value?.id);
      }

      // Update word links
      await _updateWordDutchLinkAsync(updatedWord.dutchWord, dbWord);
      await _updateWordEnglishLinksAsync(updatedWord.englishWords, dbWord);
      await nounDetailsRepository.upsertNounDetailsAsync(updatedWord, dbWord);
      await verbDetailsRepository.upsertVerbDetailsAsync(updatedWord, dbWord);

      // Process change of collection
      if (dbWord.collection.value?.id != updatedWord.collection?.id) {
        await _removeWordFromCollectionAsync(dbWord);
        if (updatedWord.collection?.id != null) {
          await _addExistingWordToCollectionAsync(
              updatedWord.collection!.id!, dbWord);
        }
      }
    });

    return true;
  }

  static void _mapUpdatedWordToEntity(DbWord dbWord, Word updatedWord) {
    dbWord.type = updatedWord.partOfSpeech;
    dbWord.contextExample = updatedWord.contextExample;
    dbWord.contextExampleTranslation = updatedWord.contextExampleTranslation;
    dbWord.userNote = updatedWord.userNote;
  }

  Future<void> _removeWordFromDutchWordsLinksAsync(
      DbWord word, int? oldDutchWordId) async {
    if (oldDutchWordId == null) return;

    final oldDutchWord = await DbContext.isar.dbDutchWords.get(oldDutchWordId);
    if (oldDutchWord != null) {
      oldDutchWord.words.remove(word);
      await oldDutchWord.words.save();
      if (oldDutchWord.audioCode == null && oldDutchWord.words.isEmpty) {
        DbContext.isar.dbWords.delete(oldDutchWordId);
      }
    }
  }

  Future<void> _removeWordFromCollectionAsync(DbWord word) async {
    if (word.collection.value?.id == null) return;

    final oldCollection =
        await DbContext.isar.dbWordCollections.get(word.collection.value!.id!);
    if (oldCollection != null) {
      oldCollection.words.remove(word);
      await oldCollection.words.save();
    }
  }

  Future<void> _addExistingWordToCollectionAsync(
      int collectionId, DbWord word) async {
    final collection = await DbContext.isar.dbWordCollections.get(collectionId);
    if (collection != null) {
      collection.words.add(word);
      await collection.words.save();
      collection.lastUpdated = DateTime.now();
      await DbContext.isar.dbWordCollections.put(collection);
    }
  }
}
