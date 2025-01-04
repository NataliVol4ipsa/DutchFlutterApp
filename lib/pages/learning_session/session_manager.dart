import 'dart:collection';

import 'package:dutch_app/local_db/repositories/word_progress_repository.dart';
import 'package:dutch_app/pages/learning_session/exercises/exercises_generator.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/pages/learning_session/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';

// Manage order of tasks and moving pointer of current task during session
class LearningSessionManager {
  final List<ExerciseType> exerciseTypes;
  final List<Word> words;
  final WordProgressRepository wordProgressRepository;
  final ExerciseAnsweredNotifier notifier;

  late List<BaseExercise> exercises;
  late Queue<BaseExercise> exercisesQueue;

  List<ExerciseSummaryDetailed>? detailedSummaries;
  SessionSummary? sessionSummary;

  LearningSessionManager(this.exerciseTypes, this.words,
      this.wordProgressRepository, this.notifier) {
    exercises = ExercisesGenerator(exerciseTypes, words).generateExcercises();
    exercisesQueue = Queue<BaseExercise>();
    exercisesQueue.addAll(exercises);
    notifier.addListener(processExerciseAnswer);
  }

  int get totalTasks => exercisesQueue.length;

  BaseExercise? get currentTask => exercisesQueue.firstOrNull;

  // 1 and not 0 because there must be NEXT task, not CURRENT task
  bool get hasNextTask => exercisesQueue.length > 1;

  void moveToNextExercise() {
    if (exercisesQueue.isNotEmpty) {
      exercisesQueue.removeFirst();
    }
  }

  void processExerciseAnswer() {
    if (!notifier.isAnswered || exercisesQueue.isEmpty) return;

    var ex = exercisesQueue.first;
    if (ex.isAnswered() && ex.answerSummary.totalCorrectAnswers == 0) {
      exercisesQueue.add(exercisesQueue.first);
    }
  }

  Future<void> processSessionResultsAsync() async {
    detailedSummaries =
        exercises.expand((ex) => ex.generateSummaries()).toList();

    await _saveDetailedSummariesAsync(detailedSummaries!);
    _generateSummary();
  }

  void _generateSummary() {
    sessionSummary = SessionSummary(
        totalWords: words.length,
        totalExercises: exercises.length,
        exerciseTypes: exerciseTypes,
        detailedSummaries: detailedSummaries!);
  }

  void endSession() {
    exercisesQueue = Queue<BaseExercise>();
  }

  Future<void> _saveDetailedSummariesAsync(
      List<ExerciseSummaryDetailed> detailedSummaries) async {
    await Future.forEach(detailedSummaries, (summary) async {
      await wordProgressRepository.updateAsync(
          summary.wordId,
          summary.exerciseType,
          summary.totalCorrectAnswers,
          summary.totalWrongAnswers);
    });
  }

  void dispose() {
    notifier.removeListener(processExerciseAnswer);
  }
}
