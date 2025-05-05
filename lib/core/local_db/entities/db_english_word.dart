import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

part 'db_english_word.g.dart';

@Collection()
class DbEnglishWord {
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String word;

  @Backlink(to: 'englishWordLinks')
  final words = IsarLinks<DbWord>();
}
