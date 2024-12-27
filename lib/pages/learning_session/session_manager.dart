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

  late List<BaseExercise> exercises;
  late List<BaseExercise> exercisesQueue;
  int currentExerciseIndex = 0;
  int get totalTasks => exercisesQueue.length;

  final WordProgressRepository wordProgressRepository;

  LearningSessionManager(
      this.learningModes, this.words, this.wordProgressRepository) {
    exercises = ExercisesGenerator(learningModes, words).generateExcercises();
    exercisesQueue = List.from(exercises);
  }
  BaseExercise get currentTask => exercisesQueue[currentExerciseIndex];

  BaseExercise? moveToNextExercise() {
    if (currentExerciseIndex < exercisesQueue.length - 1) {
      currentExerciseIndex++;
      return exercisesQueue[currentExerciseIndex];
    }
    return null;
  }

  bool get hasNextTask {
    return currentExerciseIndex < exercisesQueue.length - 1;
  }

  BaseExercise? get previousTask {
    if (currentExerciseIndex > 0) {
      currentExerciseIndex--;
      return exercisesQueue[currentExerciseIndex];
    }
    return null;
  }

  SessionSummary? sessionSummary;

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
