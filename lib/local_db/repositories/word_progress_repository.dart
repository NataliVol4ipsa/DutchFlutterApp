import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:dutch_app/local_db/entities/db_word_progress.dart';
import 'package:isar/isar.dart';

class WordProgressRepository {
  Future<DbWordProgress?> _getProgressAsync(
      int wordId, ExerciseType exerciseType) async {
    final wordProgress = await DbContext.isar.dbWordProgress
        .filter()
        .word((q) => q.idEqualTo(wordId))
        .and()
        .exerciseTypeEqualTo(exerciseType)
        .findFirst();

    return wordProgress;
  }

  Future<DbWordProgress> _createAsync(
      int wordId, ExerciseType exerciseType) async {
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
      int wordId, ExerciseType exerciseType) async {
    var existingEntry = await _getProgressAsync(wordId, exerciseType);
    if (existingEntry != null) return existingEntry;

    return await _createAsync(wordId, exerciseType);
  }

  Future<void> updateAsync(int wordId, ExerciseType exerciseType,
      int newCorrectAnswers, int newWrongAnswers) async {
    final wordProgress = await _getOrCreateAsync(wordId, exerciseType);

    wordProgress.lastPracticed = DateTime.now();
    wordProgress.correctAnswers += newCorrectAnswers;
    wordProgress.wrongAnswers += newWrongAnswers;

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbWordProgress.put(wordProgress));
  }
}
