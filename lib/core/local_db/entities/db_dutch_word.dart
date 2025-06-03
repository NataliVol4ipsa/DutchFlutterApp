import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:isar/isar.dart';

part 'db_dutch_word.g.dart';

@Collection()
class DbDutchWord {
  Id? id;

  @Index(type: IndexType.hash, unique: true)
  late String word;
  late String? audioCode;

  @Backlink(to: 'dutchWordLink')
  final words = IsarLinks<DbWord>();

  @Backlink(to: 'pluralFormWordLink')
  final pluralFormWords = IsarLinks<DbWordNounDetails>();
  @Backlink(to: 'diminutiveWordLink')
  final diminutiveWords = IsarLinks<DbWordNounDetails>();
}
