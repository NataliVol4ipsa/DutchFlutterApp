import 'package:first_project/local_db/entities/db_word_collection.dart';
import 'package:first_project/local_db/entities/db_word.dart';
import 'package:first_project/local_db/entities/db_word_progress.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class DbContext {
  static late Isar isar;

  static Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
        [DbWordSchema, DbWordCollectionSchema, DbWordProgressSchema],
        directory: appDir.path);
  }
}
