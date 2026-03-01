import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/repositories/tools/word_progress_key.dart';
import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/domain/services/spaced_repetition_algorithm.dart';
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
      case ExerciseType.basicWrite:
        return ExerciseTypeDetailed.basicWrite;
      default:
        throw Exception('Unsupported exercise type: $exerciseType');
    }
  }

  Future<Set<int>> getPracticedWordIdsAsync(List<int> wordIds) async {
    final allProgress = await wordProgressRepository.getProgressForWordsAsync(
      wordIds,
    );
    return allProgress
        .where((p) => p.lastPracticed != null)
        .map((p) => p.word.value?.id)
        .whereType<int>()
        .toSet();
  }

  /// Returns true if the user has practiced any word today.
  Future<bool> practicedTodayAsync() =>
      wordProgressRepository.practicedTodayExistsAsync();

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

  //
  // Scheduling policy
  // -----------------
  // 1. First-ever practice (lastPracticed == null):
  //      Apply SM-2 and start scheduling immediately.
  // 2. Due / overdue (now >= nextReviewDate):
  //      Normal scheduled review – apply SM-2, advance nextReviewDate.
  // 3. Within early window (future, but close to due):
  //      Count as review, but anchor nextReviewDate to the *original* due date
  //      so early review doesn't shorten the intended spacing.
  //      earlyWindow = min(12 h, intervalDays * 20 %).
  // 4. Far in the future (beyond early window):
  //      Practice-only: record lastPracticed, do NOT touch the schedule.
  void _applySessionOutcome(
    DbWordProgress progress,
    ExerciseSummaryDetailed summary,
  ) {
    final now = DateTime.now();

    final int quality;
    final bool isMistake;

    if (summary.ankiGrade != null) {
      quality = summary.ankiGrade!.quality;
      isMistake = summary.ankiGrade!.isMistake;
    } else {
      isMistake = summary.totalWrongAnswers > 0;
      quality = isMistake ? 2 : 5;
    }

    // Always stamp lastPracticed regardless of scheduling outcome.
    progress.lastPracticed = now;

    // ── Determine scheduling mode ───────────────────────────────────────────
    final bool isFirstEverPractice =
        progress.lastReviewDate == null &&
        progress.intervalDays == 0 &&
        progress.consequetiveCorrectAnswers == 0;
    final bool isDue =
        now.isAfter(progress.nextReviewDate) ||
        now.isAtSameMomentAs(progress.nextReviewDate);

    final Duration earlyWindow = _earlyWindow(progress.intervalDays);
    final Duration timeUntilDue = progress.nextReviewDate.difference(now);
    final bool isWithinEarlyWindow = !isDue && timeUntilDue <= earlyWindow;

    if (isFirstEverPractice || isDue || isWithinEarlyWindow) {
      // ── Real review ──────────────────────────────────────────────────────
      final updatedEasinessFactor =
          SpacedRepetitionAlgorithm.calculateNewEasinessFactor(
            progress.easinessFactor,
            quality,
          );
      final updatedConsecutiveCorrect = isMistake
          ? 0
          : progress.consequetiveCorrectAnswers + 1;
      final updatedIntervalDays =
          SpacedRepetitionAlgorithm.calculateNewIntervalDays(
            isMistake,
            updatedConsecutiveCorrect,
            updatedEasinessFactor,
            progress.intervalDays,
            isAnkiEasy: summary.ankiGrade == AnkiGrade.easy,
          );

      progress.easinessFactor = updatedEasinessFactor;
      progress.consequetiveCorrectAnswers = updatedConsecutiveCorrect;
      progress.intervalDays = updatedIntervalDays;
      progress.lastReviewDate = now;

      if (isWithinEarlyWindow) {
        // Anchor to original due date so we don't shorten the spacing.
        //   e.g. due March 10, practiced March 8 → next = March 10 + interval
        progress.nextReviewDate = progress.nextReviewDate.add(
          Duration(days: updatedIntervalDays),
        );
      } else {
        progress.nextReviewDate = now.add(Duration(days: updatedIntervalDays));
      }
    }
    // else: practice-only – lastPracticed was already stamped above; nothing else changes.
  }

  /// Early window = min(12 h, 20 % of the current interval).
  Duration _earlyWindow(int intervalDays) {
    if (intervalDays <= 0) return const Duration(hours: 12);
    final twentyPercent = Duration(
      minutes: (intervalDays * 0.20 * 24 * 60).round(),
    );
    const cap = Duration(hours: 12);
    return twentyPercent < cap ? twentyPercent : cap;
  }
}
