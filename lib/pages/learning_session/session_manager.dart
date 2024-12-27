import 'package:first_project/local_db/repositories/word_progress_repository.dart';
import 'package:first_project/pages/learning_session/exercises/de_het/de_het_pick_exercise.dart';
import 'package:first_project/pages/learning_session/exercises/exercises_generator.dart';
import 'package:first_project/pages/learning_session/exercises/base/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/exercise_type.dart';

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

  SessionSummary? summary;

  Future<void> processSessionResultsAsync() async {
    generateSummary();

    await Future.forEach(exercises, (exercise) async {
      if (exercise.exerciseType == ExerciseType.deHetPick) {
        DeHetPickExercise ex = exercise as DeHetPickExercise;
        await wordProgressRepository.updateAsync(
            ex.word.id,
            ExerciseType.deHetPick,
            exercise.answerSummary.totalCorrectAnswers,
            exercise.answerSummary.totalWrongAnswers);
      }
    });
  }

  void generateSummary() {
    summary = SessionSummary(
        totalExercises: exercises.length,
        correctExercises: exercises
            .where((element) => element.answerSummary.totalCorrectAnswers > 0)
            .length);
  }
}

class SessionSummary {
  final int totalExercises;
  final int correctExercises;
  late double correctPercent;

  SessionSummary(
      {required this.totalExercises, required this.correctExercises}) {
    correctPercent = correctExercises * 100 / totalExercises;
  }
}
