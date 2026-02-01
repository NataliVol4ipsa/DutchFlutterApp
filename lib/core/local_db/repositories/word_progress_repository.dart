import 'package:dutch_app/core/local_db/db_context.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:isar/isar.dart';

class WordProgressRepository {
  Future<DbWordProgress?> getAsync(
    int wordId,
    ExerciseTypeDetailed exerciseType,
  ) async {
    final wordProgress = await DbContext.isar.dbWordProgress
        .filter()
        .word((q) => q.idEqualTo(wordId))
        .and()
        .exerciseTypeEqualTo(exerciseType)
        .findFirst();

    return wordProgress;
  }

  Future<DbWordProgress> _createAsync(
    int wordId,
    ExerciseTypeDetailed exerciseType,
  ) async {
    final word = await DbContext.isar.dbWords.get(wordId);

    if (word == null) {
      throw Exception('Word with ID $wordId not found!');
    }

    final newProgress = DbWordProgress()
      ..word.value = word
      ..exerciseType = exerciseType;

    await DbContext.isar.writeTxn(() async {
      await DbContext.isar.dbWordProgress.put(newProgress);
      await newProgress.word.save();
    });

    return newProgress;
  }

  Future<DbWordProgress> _getOrCreateAsync(
    int wordId,
    ExerciseTypeDetailed exerciseType,
  ) async {
    var existingEntry = await getAsync(wordId, exerciseType);
    if (existingEntry != null) return existingEntry;

    return await _createAsync(wordId, exerciseType);
  }

  Future<void> updateAsync(
    int wordId,
    ExerciseTypeDetailed exerciseType,
    DateTime nextReviewDate,
    double easinessFactor,
    int intervalDays,
    int consequetiveCorrectAnswers,
  ) async {
    final wordProgress = await _getOrCreateAsync(wordId, exerciseType);

    wordProgress.lastPracticed = DateTime.now();
    wordProgress.consequetiveCorrectAnswers = consequetiveCorrectAnswers;
    wordProgress.nextReviewDate = nextReviewDate;
    wordProgress.easinessFactor = easinessFactor;
    wordProgress.intervalDays = intervalDays;

    await DbContext.isar.writeTxn(
      () => DbContext.isar.dbWordProgress.put(wordProgress),
    );
  }
}
