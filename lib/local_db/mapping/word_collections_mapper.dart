import 'package:first_project/core/models/word_collection.dart';
import 'package:first_project/local_db/entities/db_word_collection.dart';

class WordCollectionsMapper {
  DbWordCollection mapToEntity(WordCollection collection) {
    var newCollection = DbWordCollection();
    newCollection.name = collection.name;
    return newCollection;
  }

  List<DbWordCollection> mapToEntityList(List<WordCollection> collections) {
    return collections.map((collection) => mapToEntity(collection)).toList();
  }
}
