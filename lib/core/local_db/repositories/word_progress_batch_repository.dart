import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'dart:math';
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

  /// Returns progress records grouped by word id, one list per word.
  /// Words with no progress records are included with an empty list.
  Future<Map<int, List<DbWordProgress>>> getProgressByWordIdAsync(
    List<int> wordIds,
  ) async {
    final result = <int, List<DbWordProgress>>{};
    for (final id in wordIds) {
      final progress = await DbContext.isar.dbWordProgress
          .filter()
          .word((q) => q.idEqualTo(id))
          .findAll();
      result[id] = progress;
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

  Future<List<DbWordProgress>> getTomorrowProgressAsync(
    ExerciseTypeDetailed exerciseType,
    int limit,
  ) async {
    if (limit <= 0) return [];
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(hours: 24));

    final records = await DbContext.isar.dbWordProgress
        .where()
        .nextReviewDateBetween(now, tomorrow)
        .filter()
        .exerciseTypeEqualTo(exerciseType)
        .limit(limit)
        .findAll();

    for (final r in records) {
      await r.word.load();
    }
    return records;
  }

  Future<List<DbWordProgress>> getRecentlyLearnedProgressAsync(
    ExerciseTypeDetailed exerciseType,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final records = await DbContext.isar.dbWordProgress
        .filter()
        .exerciseTypeEqualTo(exerciseType)
        .and()
        .lastReviewDateIsNotNull()
        .findAll();

    records.sort((a, b) {
      final aDate = a.lastReviewDate!;
      final bDate = b.lastReviewDate!;
      return bDate.compareTo(aDate); // DESC
    });

    final top = records.take(limit).toList();
    for (final r in top) {
      await r.word.load();
    }
    return top;
  }

  Future<List<DbWordProgress>> getRandomProgressAsync(
    ExerciseTypeDetailed exerciseType,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final records = await DbContext.isar.dbWordProgress
        .filter()
        .exerciseTypeEqualTo(exerciseType)
        .and()
        .lastPracticedIsNotNull()
        .findAll();

    final today = DateTime.now();
    final seed = today.year * 10000 + today.month * 100 + today.day;
    final rng = Random(seed);
    records.shuffle(rng);

    final top = records.take(limit).toList();
    for (final r in top) {
      await r.word.load();
    }
    return top;
  }

  Future<List<DbWordProgress>> getWeakestProgressAsync(
    ExerciseTypeDetailed exerciseType,
    int limit,
  ) async {
    if (limit <= 0) return [];

    final records = await DbContext.isar.dbWordProgress
        .filter()
        .exerciseTypeEqualTo(exerciseType)
        .and()
        .lastPracticedIsNotNull()
        .findAll();

    records.sort((a, b) {
      // Primary: lowest ease
      final easeCompare = a.easinessFactor.compareTo(b.easinessFactor);
      if (easeCompare != 0) return easeCompare;
      // Secondary: lowest interval (less-known words)
      return a.intervalDays.compareTo(b.intervalDays);
    });

    final top = records.take(limit).toList();
    for (final r in top) {
      await r.word.load();
    }
    return top;
  }

  /// Counts distinct words that were introduced (practiced for the FIRST time)
  /// today. A word counts as "introduced today" when it has at least one
  /// progress record with [lastPracticed] today but NO record with
  /// [lastPracticed] before today (i.e. today was the very first practice).
  Future<int> countNewWordsIntroducedTodayAsync() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    // All progress records that were last practiced today.
    final todayRecords = await DbContext.isar.dbWordProgress
        .filter()
        .lastPracticedBetween(startOfDay, endOfDay)
        .findAll();

    if (todayRecords.isEmpty) return 0;

    for (final r in todayRecords) {
      await r.word.load();
    }

    final todayWordIds = todayRecords
        .map((r) => r.word.value?.id)
        .whereType<int>()
        .toSet();

    // A word is "new today" when none of its progress records carry a
    // lastPracticed date from before today.
    int count = 0;
    for (final wordId in todayWordIds) {
      final hasOlderRecord =
          await DbContext.isar.dbWordProgress
              .filter()
              .word((q) => q.idEqualTo(wordId))
              .lastPracticedLessThan(startOfDay)
              .count() >
          0;
      if (!hasOlderRecord) count++;
    }
    return count;
  }

  Future<bool> practicedTodayExistsAsync() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));

    final count = await DbContext.isar.dbWordProgress
        .filter()
        .lastPracticedBetween(startOfDay, endOfDay)
        .count();
    return count > 0;
  }
}
