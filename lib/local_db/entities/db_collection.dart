import 'package:first_project/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

//dart run build_runner build
part 'db_collection.g.dart';

@Collection()
class DbCollection {
  Id id = Isar.autoIncrement;
  late String name;
  final parentCollection = IsarLink<DbCollection>();
  // Usage: final words = await fetchedCollection?.words.load();
  final words = IsarLinks<DbWord>();
}
