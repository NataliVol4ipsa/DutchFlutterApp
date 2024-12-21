import 'package:first_project/local_db/db_context.dart';
import 'package:first_project/local_db/repositories/word_collections_repository.dart';
import 'package:first_project/local_db/repositories/words_repository.dart';
import 'package:provider/provider.dart';

List<Provider> databaseProviders() {
  return [
    Provider<DbContext>(create: (_) => DbContext()),
    Provider<WordsRepository>(create: (_) => WordsRepository()),
    Provider<WordCollectionsRepository>(
        create: (_) => WordCollectionsRepository()),
  ];
}
