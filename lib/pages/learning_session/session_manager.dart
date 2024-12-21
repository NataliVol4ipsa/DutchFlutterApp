import 'package:first_project/pages/learning_session/exercises/exercises_generator.dart';
import 'package:first_project/pages/learning_session/exercises/base_exercise.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

// Manage order of tasks and moving pointer of current task during session
class LearningSessionManager {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  late List<BaseExercise> exercises;
  int currentExerciseIndex = 0;
  late int totalTasks;

  LearningSessionManager(this.learningModes, this.words) {
    exercises = ExercisesGenerator(learningModes, words).generateExcercises();
    totalTasks = exercises.length;
  }
  BaseExercise get currentTask => exercises[currentExerciseIndex];

  BaseExercise? moveToNextExercise() {
    if (currentExerciseIndex < exercises.length - 1) {
      currentExerciseIndex++;
      return exercises[currentExerciseIndex];
    }
    return null;
  }

  bool get hasNextTask {
    return currentExerciseIndex < exercises.length - 1;
  }

  BaseExercise? get previousTask {
    if (currentExerciseIndex > 0) {
      currentExerciseIndex--;
      return exercises[currentExerciseIndex];
    }
    return null;
  }
}
