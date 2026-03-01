import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/types/exercise_type_detailed.dart';
import 'package:isar/isar.dart';

part 'db_word_progress.g.dart';

// Degree to which user knows word
@Collection()
class DbWordProgress {
  Id? id;
  @Index(
    composite: [CompositeIndex('exerciseType')],
  ) // Composite index with exerciseType
  final word = IsarLink<DbWord>();
  @enumerated
  late ExerciseTypeDetailed exerciseType;

  /// Updated on every practice attempt (scheduled or extra).
  DateTime? lastPracticed;

  /// Updated only when the practice counted as a real scheduled review
  /// (word was due/overdue, or within the early window).
  DateTime? lastReviewDate;
  late bool dontShowAgain = false;
  @Index()
  late DateTime nextReviewDate = DateTime.now();
  // how easy is word
  late double easinessFactor = 2.5;
  // how many days should current interval last
  late int intervalDays = 0;
  late int consequetiveCorrectAnswers = 0;
}
