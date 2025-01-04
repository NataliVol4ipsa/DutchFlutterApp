import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/local_db/entities/db_word_progress.dart';
import 'package:isar/isar.dart';

part 'db_word.g.dart';

@Collection()
class DbWord {
  Id? id;
  late String dutchWord;
  late String englishWord;
  @enumerated
  late WordType type;
  @enumerated
  late DeHetType deHet;
  late String? pluralForm;
  late String? tag;
  final collection = IsarLink<DbWordCollection>();
  @Backlink(to: 'word')
  final progress = IsarLinks<DbWordProgress>();
}
