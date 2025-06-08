import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
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

  @Backlink(to: 'infinitiveWordLink')
  final infinitiveVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'completedParticipleWordLink')
  final completedParticiples = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'auxiliaryVerbWordLink')
  final auxiliaryVerbs = IsarLinks<DbWordVerbDetails>();

  @Backlink(to: 'imperativeInformalWordLink')
  final imperativeInformalVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'imperativeFormalWordLink')
  final imperativeFormalVerbs = IsarLinks<DbWordVerbDetails>();

  @Backlink(to: 'presentParticipleInflectedWordLink')
  final presentParticipleInflectedVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentParticipleUninflectedWordLink')
  final presentParticipleUninflectedVerbs = IsarLinks<DbWordVerbDetails>();

  @Backlink(to: 'presentTenseIkWordLink')
  final presentIkVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseJijVraagWordLink')
  final presentJijVraagVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseJijWordLink')
  final presentJijVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseUWordLink')
  final presentUVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseHijZijHetWordLink')
  final presentHijZijHetVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseWijWordLink')
  final presentWijVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseJullieWordLink')
  final presentJullieVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'presentTenseZijWordLink')
  final presentZijVerbs = IsarLinks<DbWordVerbDetails>();

  @Backlink(to: 'pastTenseIkWordLink')
  final pastIkVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'pastTenseJijWordLink')
  final pastJijVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'pastTenseHijZijHetWordLink')
  final pastHijZijHetVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'pastTenseWijWordLink')
  final pastWijVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'pastTenseJullieWordLink')
  final pastJullieVerbs = IsarLinks<DbWordVerbDetails>();
  @Backlink(to: 'pastTenseZijWordLink')
  final pastZijVerbs = IsarLinks<DbWordVerbDetails>();
}
