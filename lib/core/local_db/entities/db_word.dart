import 'package:dutch_app/core/local_db/entities/db_dutch_word.dart';
import 'package:dutch_app/core/local_db/entities/db_english_word.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';
import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:isar/isar.dart';

part 'db_word.g.dart';

@Collection()
class DbWord {
  Id? id;

  late String? dutchWord;
  late String? englishWord;
  @enumerated
  late WordType type;
  @enumerated
  late DeHetType deHet;
  late String? pluralForm;
  final collection = IsarLink<DbWordCollection>();
  @Backlink(to: 'word')
  final progress = IsarLinks<DbWordProgress>();
  late String? contextExample;
  late String? contextExampleTranslation;
  late String? userNote;
  late String? audioCode;

  final dutchWordLink = IsarLink<DbDutchWord>();
  final englishWordLinks = IsarLinks<DbEnglishWord>();
}
