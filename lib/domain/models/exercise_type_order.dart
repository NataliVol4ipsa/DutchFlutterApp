import 'package:dutch_app/domain/types/exercise_type_detailed.dart';

class ExerciseTypeTrigger {
  final ExerciseTypeDetailed prerequisite;
  final int requiredCorrectAnswers;

  const ExerciseTypeTrigger({
    required this.prerequisite,
    required this.requiredCorrectAnswers,
  });
}

class ExerciseTypeOrder {
  static const Map<ExerciseTypeDetailed, ExerciseTypeTrigger?> triggers = {
    ExerciseTypeDetailed.flipCardDutchEnglish: null,
    ExerciseTypeDetailed.flipCardEnglishDutch: ExerciseTypeTrigger(
      prerequisite: ExerciseTypeDetailed.flipCardDutchEnglish,
      requiredCorrectAnswers: 1,
    ),
    ExerciseTypeDetailed.basicWrite: ExerciseTypeTrigger(
      prerequisite: ExerciseTypeDetailed.flipCardDutchEnglish,
      requiredCorrectAnswers: 3,
    ),
  };

  static bool isTracked(ExerciseTypeDetailed type) =>
      triggers.containsKey(type);

  static List<ExerciseTypeDetailed> getNewlyUnlockedTypes(
    ExerciseTypeDetailed completedType,
    int consecutiveCorrect,
  ) {
    return triggers.entries
        .where(
          (e) =>
              e.value?.prerequisite == completedType &&
              consecutiveCorrect >= e.value!.requiredCorrectAnswers,
        )
        .map((e) => e.key)
        .toList();
  }

  /// Returns the set of [ExerciseTypeDetailed] that are currently unlocked for
  /// a word given its existing progress records.
  ///
  /// [progressByType] maps each tracked exercise type to the word's current
  /// consecutiveCorrectAnswers count for that type.  Types with no progress
  /// record are implicitly 0.
  static Set<ExerciseTypeDetailed> unlockedTypesForWord(
    Map<ExerciseTypeDetailed, int> progressByType,
  ) {
    final result = <ExerciseTypeDetailed>{};
    for (final entry in triggers.entries) {
      final type = entry.key;
      final trigger = entry.value;
      if (trigger == null) {
        // No prerequisite – always available.
        result.add(type);
      } else if ((progressByType[trigger.prerequisite] ?? 0) >=
          trigger.requiredCorrectAnswers) {
        result.add(type);
      }
    }
    return result;
  }
}
