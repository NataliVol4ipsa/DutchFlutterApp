import 'package:first_project/pages/learning_flow/learning_tasks/learning_tasks_generator.dart';
import 'package:first_project/pages/learning_flow/learning_tasks/base_learning_mode_task.dart';
import 'package:first_project/core/models/word.dart';
import 'package:first_project/core/types/learning_mode_type.dart';

class LearningFlowManager {
  final List<LearningModeType> learningModes;
  final List<Word> words;

  late List<BaseLearningModeTask> tasks;
  int currentTaskIndex = 0;
  late int totalTasks;

  LearningFlowManager(this.learningModes, this.words) {
    tasks = LearningTasksGenerator(learningModes, words).generateExcercises();
    totalTasks = tasks.length;
  }
  BaseLearningModeTask get currentTask => tasks[currentTaskIndex];

  BaseLearningModeTask? moveToNextTask() {
    if (currentTaskIndex < tasks.length - 1) {
      currentTaskIndex++;
      return tasks[currentTaskIndex];
    }
    return null;
  }

  bool get hasNextTask {
    return currentTaskIndex < tasks.length - 1;
  }

  BaseLearningModeTask? get previousTask {
    if (currentTaskIndex > 0) {
      currentTaskIndex--;
      return tasks[currentTaskIndex];
    }
    return null;
  }
}
