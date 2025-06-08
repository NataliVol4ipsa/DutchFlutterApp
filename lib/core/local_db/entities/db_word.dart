import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_noun_details.dart';
import 'package:dutch_app/core/local_db/entities/db_word_verb_details.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:isar/isar.dart';

part 'db_word.g.dart';

@Collection()
class DbWord {
  Id? id;

  @enumerated
  late PartOfSpeech type;
  @enumerated
  final collection = IsarLink<DbWordCollection>();
  @Backlink(to: 'word')
  final progress = IsarLinks<DbWordProgress>();
  late String? contextExample;
  late String? contextExampleTranslation;
  late String? userNote;

  final dutchWordLink = IsarLink<DbDutchWord>();
  final englishWordLinks = IsarLinks<DbEnglishWord>();
  final nounDetailsLink = IsarLink<DbWordNounDetails>();
  final verbDetailsLink = IsarLink<DbWordVerbDetails>();
}
