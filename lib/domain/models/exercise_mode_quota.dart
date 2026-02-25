import 'package:dutch_app/domain/types/exercise_type.dart';

/// Defines the allocation of exercises across practice modes.
///
/// [quotaByType] maps each [ExerciseType] to a relative proportion.
/// Values should be non-negative; only types with value > 0 are active.
///
/// This is the extension point for future customisation – e.g. mixing
/// flip-card with de-het pick. For the current MVP the only preset is
/// [flipCardOnly] (100 % flip-card).
class ExerciseModeQuota {
  final Map<ExerciseType, double> quotaByType;

  const ExerciseModeQuota(this.quotaByType);

  /// Exercise types that actually participate (quota > 0).
  List<ExerciseType> get activeTypes =>
      quotaByType.entries.where((e) => e.value > 0).map((e) => e.key).toList();

  /// MVP preset: 100 % of exercises use [ExerciseType.flipCard].
  static const ExerciseModeQuota flipCardOnly = ExerciseModeQuota({
    ExerciseType.flipCard: 1.0,
  });
}
