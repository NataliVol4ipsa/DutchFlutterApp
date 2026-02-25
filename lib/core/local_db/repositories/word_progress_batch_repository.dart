import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:isar/isar.dart';

class WordProgressBatchRepository {
  final WordProgressRepository wordProgressRepository;

  WordProgressBatchRepository(this.wordProgressRepository);

  Future<Map<WordProgressKey, DbWordProgress>> getOrCreateManyAsync(
    List<WordProgressKey> keys,
  ) async {
    final uniqueKeys = keys.toSet().toList();
    final result = <WordProgressKey, DbWordProgress>{};
    final missingKeys = <WordProgressKey>[];

    for (final key in uniqueKeys) {
      final existing = await wordProgressRepository.getAsync(
        key.wordId,
        key.exerciseType,
      );
      if (existing != null) {
        result[key] = existing;
      } else {
        missingKeys.add(key);
      }
    }

    if (missingKeys.isEmpty) return result;

    final missingWordIds = missingKeys
        .map((key) => key.wordId)
        .toSet()
        .toList();
    final words = await DbContext.isar.dbWords.getAll(missingWordIds);
    final wordsById = <int, DbWord>{};
    for (final word in words) {
      if (word != null) {
        wordsById[word.id!] = word;
      }
    }

    final newProgressList = <DbWordProgress>[];
    for (final key in missingKeys) {
      final word = wordsById[key.wordId];
      if (word == null) {
        throw Exception('Word with ID ${key.wordId} not found!');
      }

      final newProgress = DbWordProgress()
        ..word.value = word
        ..exerciseType = key.exerciseType;

      newProgressList.add(newProgress);
      result[key] = newProgress;
    }

    await DbContext.isar.writeTxn(() async {
      await DbContext.isar.dbWordProgress.putAll(newProgressList);
      for (final progress in newProgressList) {
        await progress.word.save();
      }
    });

    return result;
  }

  Future<void> saveAllAsync(List<DbWordProgress> progressList) async {
    if (progressList.isEmpty) return;
    await DbContext.isar.writeTxn(
      () => DbContext.isar.dbWordProgress.putAll(progressList),
    );
  }

  Future<List<DbWordProgress>> getProgressForWordsAsync(
    List<int> wordIds,
  ) async {
    final result = <DbWordProgress>[];
    for (final id in wordIds) {
      final progress = await DbContext.isar.dbWordProgress
          .filter()
          .word((q) => q.idEqualTo(id))
          .findAll();
      result.addAll(progress);
    }
    return result;
  }

  Future<List<DbWordProgress>> getDueProgressAsync(
    ExerciseTypeDetailed exerciseType,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final now = DateTime.now();

    // Index traversal is ascending, so the most overdue records come first.
    final records = await DbContext.isar.dbWordProgress
        .where()
        .nextReviewDateLessThan(now)
        .filter()
        .exerciseTypeEqualTo(exerciseType)
        .and()
        .lastPracticedIsNotNull()
        .limit(limit)
        .findAll();

    for (final r in records) {
      await r.word.load();
    }

    return records;
  }
}
