import 'package:dutch_app/domain/models/word_exercises_to_unlock.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/pages/learning_session/exercises/shared/exercise_summary_detailed.dart';

const _flipCardGroup = {ExerciseType.flipCard, ExerciseType.flipCardReverse};

class SessionSummary {
  final int totalWords;
  final int totalExercises;
  final List<ExerciseType> exerciseTypes;
  final List<ExerciseSummaryDetailed> detailedSummaries;
  final List<WordExercisesToUnlock> newlyUnlockedExercises;

  late int totalExerciseTypes;
  late int totalMistakes;
  late double successRatePercent;
  late double mistakeRatePercent;
  late List<SingleExerciseTypeSummary> summariesPerExercise;

  SessionSummary({
    required this.totalWords,
    required this.totalExercises,
    required this.exerciseTypes,
    required this.detailedSummaries,
    this.newlyUnlockedExercises = const [],
  }) {
    summariesPerExercise = _buildSummariesPerExercise(
      exerciseTypes,
      detailedSummaries,
    );

    totalExerciseTypes = summariesPerExercise.length;

    totalMistakes = detailedSummaries.fold(
      0,
      (sum, detail) => sum + detail.totalWrongAnswers,
    );
    int totalAttempts = totalExercises + totalMistakes;
    mistakeRatePercent = totalExercises > 0
        ? (totalMistakes * 100 / totalAttempts)
        : 0;
    successRatePercent = 100 - mistakeRatePercent;
  }

  static List<SingleExerciseTypeSummary> _buildSummariesPerExercise(
    List<ExerciseType> exerciseTypes,
    List<ExerciseSummaryDetailed> detailedSummaries,
  ) {
    final groups = <Set<ExerciseType>>[];

    final flipCardTypes = exerciseTypes
        .where((t) => _flipCardGroup.contains(t))
        .toSet();
    if (flipCardTypes.isNotEmpty) {
      groups.add(flipCardTypes);
    }

    for (final type in exerciseTypes) {
      if (!_flipCardGroup.contains(type)) {
        groups.add({type});
      }
    }

    return groups
        .map(
          (g) => SingleExerciseTypeSummary(
            exerciseTypes: g,
            detailedSummaries: detailedSummaries,
          ),
        )
        .where((s) => s.totalWords > 0)
        .toList();
  }
}

class SingleExerciseTypeSummary {
  final Set<ExerciseType> exerciseTypes;

  late List<ExerciseSummaryDetailed> summaries;
  late int totalMistakes;
  late double successRatePercent;
  late double mistakeRatePercent;
  late int totalWords;

  String get displayLabel {
    if (exerciseTypes.length == 1) return exerciseTypes.first.label;
    return ExerciseType.flipCard.label;
  }

  ExerciseType get exerciseType => exerciseTypes.first;

  SingleExerciseTypeSummary({
    required this.exerciseTypes,
    required List<ExerciseSummaryDetailed> detailedSummaries,
  }) {
    summaries = detailedSummaries
        .where((s) => exerciseTypes.contains(s.exerciseType))
        .toList();

    totalWords = summaries.length;

    totalMistakes = summaries.fold(
      0,
      (sum, detail) => sum + detail.totalWrongAnswers,
    );
    int totalAttempts = totalWords + totalMistakes;
    mistakeRatePercent = totalAttempts > 0
        ? (totalMistakes * 100 / totalAttempts)
        : 0;
    successRatePercent = 100 - mistakeRatePercent;
  }
}
