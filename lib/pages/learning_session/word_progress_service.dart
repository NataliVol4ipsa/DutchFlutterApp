import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/types/anki_grade.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';

// Main spaced repetition logic calculation
class WordProgressService {
  final WordProgressBatchRepository wordProgressRepository;

  WordProgressService({required this.wordProgressRepository});

  //todo rewrite with proper ex type
  ExerciseTypeDetailed _mapToDetailedExerciseType(ExerciseType exerciseType) {
    switch (exerciseType) {
      case ExerciseType.flipCard:
        return ExerciseTypeDetailed.flipCardDutchEnglish;
      case ExerciseType.deHetPick:
        return ExerciseTypeDetailed.deHetPick;
      default:
        throw Exception('Unsupported exercise type: $exerciseType');
    }
  }

  Future<void> processSessionResults(
    List<ExerciseSummaryDetailed> detailedSummaries,
  ) async {
    if (detailedSummaries.isEmpty) return;

    final keys = detailedSummaries
        .map(
          (summary) => WordProgressKey(
            summary.wordId,
            _mapToDetailedExerciseType(summary.exerciseType),
          ),
        )
        .toList();

    final progressByKey = await wordProgressRepository.getOrCreateManyAsync(
      keys,
    );

    final updatedProgress = <DbWordProgress>[];
    for (final summary in detailedSummaries) {
      final key = WordProgressKey(
        summary.wordId,
        _mapToDetailedExerciseType(summary.exerciseType),
      );
      final progress = progressByKey[key];
      if (progress == null) continue;

      _applySessionOutcome(progress, summary);
      updatedProgress.add(progress);
    }

    await wordProgressRepository.saveAllAsync(updatedProgress);
  }

  //todo do not update repetition date if answered correctly today already
  //todo handle other cases of out-of-schedule user practice outcomes
  void _applySessionOutcome(
    DbWordProgress progress,
    ExerciseSummaryDetailed summary,
  ) {
    final now = DateTime.now();

    // Anki-mode: use the explicit grade quality (1, 2, 4, 5)
    // Simplified mode: map know/don't-know to quality 5 / 2
    final int quality;
    final bool isMistake;

    if (summary.ankiGrade != null) {
      quality = summary.ankiGrade!.quality;
      isMistake = summary.ankiGrade!.isMistake;
    } else {
      isMistake = summary.totalWrongAnswers > 0;
      quality = isMistake ? 2 : 5;
    }

    final updatedEasinessFactor = _calculateNewEasinessFactor(
      progress.easinessFactor,
      quality,
    );

    final updatedConsequetiveCorrectAnswers = isMistake
        ? 0
        : progress.consequetiveCorrectAnswers + 1;

    final updatedIntervalDays = _calculateNewIntervalDays(
      isMistake,
      updatedConsequetiveCorrectAnswers,
      updatedEasinessFactor,
      progress.intervalDays,
      isAnkiEasy: summary.ankiGrade == AnkiGrade.easy,
    );

    progress.lastPracticed = now;
    progress.consequetiveCorrectAnswers = updatedConsequetiveCorrectAnswers;
    progress.intervalDays = updatedIntervalDays;
    progress.easinessFactor = updatedEasinessFactor;
    progress.nextReviewDate = now.add(Duration(days: updatedIntervalDays));
  }

  double _calculateNewEasinessFactor(
    double currentEasinessFactor,
    int quality,
  ) {
    final easinessFactorDelta =
        (0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02));
    var newEasinessFactor = currentEasinessFactor + easinessFactorDelta;

    if (newEasinessFactor < 1.3) newEasinessFactor = 1.3;
    if (newEasinessFactor > 2.5) newEasinessFactor = 2.5;

    return newEasinessFactor;
  }

  int _calculateNewIntervalDays(
    bool isMistake,
    int updatedConsequetiveCorrectAnswers,
    double updatedEasinessFactor,
    int currentIntervalDays, {
    bool isAnkiEasy = false,
  }) {
    if (isMistake) {
      return 1;
    }
    if (updatedConsequetiveCorrectAnswers == 1) {
      return 1;
    }
    if (updatedConsequetiveCorrectAnswers == 2) {
      return 6;
    }
    final multiplier = isAnkiEasy
        ? updatedEasinessFactor * 1.3
        : updatedEasinessFactor;
    return (currentIntervalDays * multiplier).round().clamp(1, 365);
  }
}
