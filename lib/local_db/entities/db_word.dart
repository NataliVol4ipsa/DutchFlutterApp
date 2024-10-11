import 'package:first_project/core/types/de_het_type.dart';
import 'package:first_project/core/types/word_type.dart';
import 'package:isar/isar.dart';

//dart run build_runner build
part 'db_word.g.dart';

@Collection()
class DbWord {
  Id id = Isar.autoIncrement;
  late String dutchWord;
  late String englishWord;
  @enumerated
  late WordType type;
  @enumerated
  late DeHetType deHet;
  late String? pluralForm;
  late String? tag;
}
