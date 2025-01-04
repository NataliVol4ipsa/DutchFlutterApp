import 'package:dutch_app/core/types/exercise_type.dart';
import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

part 'db_word_progress.g.dart';

// Degree to which user knows word
@Collection()
class DbWordProgress {
  Id? id;
  @Index(composite: [
    CompositeIndex('exerciseType')
  ]) // Composite index with exerciseType
  final word = IsarLink<DbWord>();
  @enumerated
  late ExerciseType exerciseType;
  late int correctAnswers = 0;
  late int wrongAnswers = 0;
  DateTime? lastPracticed;
  late bool dontShowAgain = false;
}
