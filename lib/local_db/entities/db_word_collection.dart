import 'package:dutch_app/local_db/entities/db_word.dart';
import 'package:isar/isar.dart';

part 'db_word_collection.g.dart';

@Collection()
class DbWordCollection {
  Id? id;
  late String name;
  final parentCollection = IsarLink<DbWordCollection>();
  // Usage: final words = await fetchedCollection?.words.load();
  @Backlink(to: 'collection')
  final words = IsarLinks<DbWord>();
}
