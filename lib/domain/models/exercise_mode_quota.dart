import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';

class ExerciseModeQuota {
  final Map<ExerciseType, double> quotaByType;

  const ExerciseModeQuota(this.quotaByType);

  List<ExerciseType> get activeTypes =>
      quotaByType.entries.where((e) => e.value > 0).map((e) => e.key).toList();

  List<ExerciseTypeDetailed> get activeDetailedTypes =>
      activeTypes.expand((t) => t.detailedTypes).toSet().toList();

  static const ExerciseModeQuota flipCardOnly = ExerciseModeQuota({
    ExerciseType.flipCard: 1.0,
  });

  static const ExerciseModeQuota flipCardAndWriting = ExerciseModeQuota({
    ExerciseType.flipCard: 1.0,
    ExerciseType.basicWrite: 1.0,
  });
}
