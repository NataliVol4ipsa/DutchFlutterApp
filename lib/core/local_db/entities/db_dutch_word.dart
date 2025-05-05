// Degree to which user knows word
import 'package:isar/isar.dart';

part 'db_dutch_word.g.dart';

@Collection()
class DbDutchWord {
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String word;
  late String audioCode;
}
