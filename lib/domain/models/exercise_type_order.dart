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

  static Set<ExerciseTypeDetailed> unlockedTypesForWord(
    Map<ExerciseTypeDetailed, int> progressByType,
  ) {
    final result = <ExerciseTypeDetailed>{};
    for (final entry in triggers.entries) {
      final type = entry.key;
      final trigger = entry.value;
      if (trigger == null) {
        result.add(type);
      } else if (progressByType.containsKey(type)) {
        // A DB record for this type already exists - it was unlocked before;
        result.add(type);
      } else if ((progressByType[trigger.prerequisite] ?? 0) >=
          trigger.requiredCorrectAnswers) {
        result.add(type);
      }
    }
    return result;
  }
}
