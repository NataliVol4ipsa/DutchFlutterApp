import 'package:dutch_app/core/local_db/entities/db_word_collection.dart';
import 'package:dutch_app/core/local_db/entities/db_word.dart';
import 'package:dutch_app/core/local_db/entities/db_word_progress.dart';
import 'package:dutch_app/core/local_db/entities/db_settings.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart'; // todo move to separate file

class DbContext {
  static late Isar isar;

  static Future<void> initialize() async {
    final appDir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([
      DbWordSchema,
      DbWordCollectionSchema,
      DbWordProgressSchema,
      DbSettingsSchema
    ], directory: appDir.path);
  }
}
