import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/models/exercise_type_order.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_exercises_to_unlock.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';

class ExerciseUnlockService {
  final WordProgressBatchRepository repository;

  ExerciseUnlockService({required this.repository});

  Future<Map<int, Set<ExerciseTypeDetailed>>> snapshotUnlockedTypesAsync(
    List<int> wordIds,
  ) async {
    final progressByWordId = await repository.getProgressByWordIdAsync(wordIds);
    return _computeUnlockedPerWord(wordIds, progressByWordId);
  }

  Future<List<WordExercisesToUnlock>> computeAndPersistNewUnlocksAsync({
    required List<Word> words,
    required Map<int, Set<ExerciseTypeDetailed>> preSessionUnlocked,
  }) async {
    if (words.isEmpty) return const [];

    final wordIds = words.map((w) => w.id).toList();
    final postProgress = await repository.getProgressByWordIdAsync(wordIds);
    final postUnlocked = _computeUnlockedPerWord(wordIds, postProgress);

    final results = <WordExercisesToUnlock>[];
    final newKeys = <WordProgressKey>[];

    for (final word in words) {
      final pre = preSessionUnlocked[word.id] ?? const {};
      final post = postUnlocked[word.id] ?? const {};
      final diff = post.difference(pre).toList();
      if (diff.isNotEmpty) {
        for (final type in diff) {
          newKeys.add(WordProgressKey(word.id, type));
        }
        results.add(WordExercisesToUnlock(word: word, newlyUnlocked: diff));
      }
    }

    if (newKeys.isNotEmpty) {
      await repository.getOrCreateManyAsync(newKeys);
    }

    return results;
  }

  static Map<int, Set<ExerciseTypeDetailed>> _computeUnlockedPerWord(
    List<int> wordIds,
    Map<int, List<DbWordProgress>> progressByWordId,
  ) {
    return {
      for (final id in wordIds)
        id: ExerciseTypeOrder.unlockedTypesForWord({
          for (final p in (progressByWordId[id] ?? []))
            p.exerciseType: p.consequetiveCorrectAnswers,
        }),
    };
  }
}
