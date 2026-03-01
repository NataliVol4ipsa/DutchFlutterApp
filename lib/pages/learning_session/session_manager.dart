import 'dart:collection';
import 'package:dutch_app/pages/learning_session/exercises/exercises_generator.dart';
import 'package:dutch_app/pages/learning_session/base/base_exercise.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/pages/learning_session/summary/session_summary.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';

// Manage order of tasks and moving pointer of current task during session
class LearningSessionManager {
  final List<ExerciseType> exerciseTypes;
  final List<Word> words;
  final WordProgressService wordProgressService;
  final ExerciseAnsweredNotifier notifier;
  final bool useAnkiMode;

  late List<BaseExercise> exercises;
  late Queue<BaseExercise> exercisesQueue;

  List<ExerciseSummaryDetailed>? detailedSummaries;
  SessionSummary? sessionSummary;

  final bool includePhrasesInWriting;

  LearningSessionManager(
    this.exerciseTypes,
    this.words,
    this.wordProgressService,
    this.notifier, {
    this.useAnkiMode = false,
    this.includePhrasesInWriting = false,
  }) {
    exercises = ExercisesGenerator(
      exerciseTypes,
      words,
      useAnkiMode,
      includePhrasesInWriting: includePhrasesInWriting,
    ).generateExcercises();
    exercisesQueue = Queue<BaseExercise>();
    exercisesQueue.addAll(exercises);
    notifier.addListener(processExerciseAnswer);
  }

  int get totalTasks => exercisesQueue.length;

  BaseExercise? get currentTask => exercisesQueue.firstOrNull;

  bool get hasNextTask => exercisesQueue.length > 1;
  bool get isSessionComplete => exercisesQueue.isEmpty;

  void moveToNextExercise() {
    if (exercisesQueue.isNotEmpty) {
      exercisesQueue.removeFirst();
    }
  }

  void processExerciseAnswer() {
    if (!notifier.isAnswered || exercisesQueue.isEmpty) return;

    var ex = exercisesQueue.first;
    if (ex.isAnswered() &&
        ex.answerSummary.totalCorrectAnswers < ex.numOfRequiredWords) {
      exercisesQueue.add(exercisesQueue.first);
    }
  }

  Future<void> processSessionResultsAsync() async {
    detailedSummaries = exercises
        .expand((ex) => ex.generateSummaries())
        .toList();

    await wordProgressService.processSessionResults(detailedSummaries!);
    _generateSummary();
  }

  void _generateSummary() {
    sessionSummary = SessionSummary(
      totalWords: words.length,
      totalExercises: exercises.length,
      exerciseTypes: exerciseTypes,
      detailedSummaries: detailedSummaries!,
    );
  }

  void endSession() {
    exercisesQueue = Queue<BaseExercise>();
  }

  void dispose() {
    notifier.removeListener(processExerciseAnswer);
  }
}
