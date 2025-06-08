import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

part 'db_word_verb_details.g.dart';

@Collection()
class DbWordVerbDetails {
  Id? id;

  final infinitiveWordLink = IsarLink<DbDutchWord>();
  final completedParticipleWordLink = IsarLink<DbDutchWord>();
  final auxiliaryVerbWordLink = IsarLink<DbDutchWord>();

  final imperativeInformalWordLink = IsarLink<DbDutchWord>();
  final imperativeFormalWordLink = IsarLink<DbDutchWord>();

  final presentParticipleInflectedWordLink = IsarLink<DbDutchWord>();
  final presentParticipleUninflectedWordLink = IsarLink<DbDutchWord>();

  final presentTenseIkWordLink = IsarLink<DbDutchWord>();
  final presentTenseJijVraagWordLink = IsarLink<DbDutchWord>();
  final presentTenseJijWordLink = IsarLink<DbDutchWord>();
  final presentTenseUWordLink = IsarLink<DbDutchWord>();
  final presentTenseHijZijHetWordLink = IsarLink<DbDutchWord>();
  final presentTenseWijWordLink = IsarLink<DbDutchWord>();
  final presentTenseJullieWordLink = IsarLink<DbDutchWord>();
  final presentTenseZijWordLink = IsarLink<DbDutchWord>();

  final pastTenseIkWordLink = IsarLink<DbDutchWord>();
  final pastTenseJijWordLink = IsarLink<DbDutchWord>();
  final pastTenseHijZijHetWordLink = IsarLink<DbDutchWord>();
  final pastTenseWijWordLink = IsarLink<DbDutchWord>();
  final pastTenseJullieWordLink = IsarLink<DbDutchWord>();
  final pastTenseZijWordLink = IsarLink<DbDutchWord>();

  @Backlink(to: 'verbDetailsLink')
  final wordLink = IsarLink<DbWord>();
}
