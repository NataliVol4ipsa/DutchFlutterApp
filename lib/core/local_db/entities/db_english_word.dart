// Degree to which user knows word
import 'package:isar/isar.dart';

part 'db_english_word.g.dart';

@Collection()
class DbEnglishWord {
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String word;
}
