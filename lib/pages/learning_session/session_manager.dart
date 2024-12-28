import 'dart:collection';

import 'package:first_project/local_db/repositories/word_progress_repository.dart';
import 'package:first_project/pages/learning_session/exercises/exercises_generator.dart';
import 'package:first_project/pages/learning_session/exercises/base/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/exercise_type.dart';
import 'package:first_project/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:first_project/pages/learning_session/summary/session_summary.dart';

// Manage order of tasks and moving pointer of current task during session
class LearningSessionManager {
  final List<ExerciseType> learningModes;
  final List<Word> words;
  final WordProgressRepository wordProgressRepository;

  late List<BaseExercise> exercises;
  late Queue<BaseExercise> exercisesQueue;

  SessionSummary? sessionSummary;

  LearningSessionManager(
      this.learningModes, this.words, this.wordProgressRepository) {
    exercises = ExercisesGenerator(learningModes, words).generateExcercises();
    exercisesQueue = Queue<BaseExercise>();
    exercisesQueue.addAll(exercises);
  }

  int get totalTasks => exercisesQueue.length;

  BaseExercise? get currentTask => exercisesQueue.firstOrNull;

  // 1 and not 0 because there must be NEXT task, not CURRENT task
  bool get hasNextTask => exercisesQueue.length > 1;

  void moveToNextExercise() {
    _processCurrentAnswer();
    if (exercisesQueue.isNotEmpty) {
      exercisesQueue.removeFirst();
    }
  }

  void _processCurrentAnswer() {}

  Future<void> processSessionResultsAsync() async {
    _generateSessionSummary();

    await _saveDetailedSummariesAsync();
  }

  void _generateSessionSummary() {
    sessionSummary = SessionSummary(
        totalExercises: exercises.length,
        correctExercises: exercises
            .where((element) => element.answerSummary.totalCorrectAnswers > 0)
            .length);
  }

  Future<void> _saveDetailedSummariesAsync() async {
    List<ExerciseSummaryDetailed> detailedSummaries =
        exercises.expand((ex) => ex.generateSummaries()).toList();

    await Future.forEach(detailedSummaries, (summary) async {
      await wordProgressRepository.updateAsync(
          summary.wordId,
          summary.exerciseType,
          summary.totalCorrectAnswers,
          summary.totalWrongAnswers);
    });
  }
}
