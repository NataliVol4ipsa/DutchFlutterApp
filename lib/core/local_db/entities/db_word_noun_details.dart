import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:isar/isar.dart';

part 'db_word_noun_details.g.dart';

@Collection()
class DbWordNounDetails {
  Id? id;

  @enumerated
  late DeHetType deHet;

  final pluralFormWordLink = IsarLink<DbDutchWord>();
  final diminutiveWordLink = IsarLink<DbDutchWord>();

  @Backlink(to: 'nounDetailsLink')
  final wordLink = IsarLink<DbWord>();
}
