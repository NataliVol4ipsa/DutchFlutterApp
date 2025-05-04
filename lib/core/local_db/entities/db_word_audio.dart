// Degree to which user knows word
import 'package:isar/isar.dart';

part 'db_word_audio.g.dart';

@Collection()
class DbWordAudio {
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String word;
  late String code;
}
