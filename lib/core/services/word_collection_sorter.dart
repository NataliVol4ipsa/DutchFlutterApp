import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/services/collection_permission_service.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_collection_model.dart';

class WordCollectionSorter {
  static void sortCollections(List<WordCollection> dbCollections) {
    dbCollections.sort((c1, c2) {
      // Priority 1: defaultId goes first
      if (c1.id == CollectionPermissionService.defaultCollectionId) return -1;
      if (c2.id == CollectionPermissionService.defaultCollectionId) return 1;

      // Priority 2: sort by lastUpdated descending (nulls treated as oldest)
      final updatedCompare = (c2.lastUpdated ??
              DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(c1.lastUpdated ?? DateTime.fromMillisecondsSinceEpoch(0));
      if (updatedCompare != 0) return updatedCompare;

      // Priority 3: sort by name ascending
      return c1.name.compareTo(c2.name);
    });
  }

  static void sort(List<SelectableWordCollectionModel> dbCollections) {
    dbCollections.sort((c1, c2) {
      // Priority 1: sort by lastUpdated descending (nulls treated as oldest)
      final updatedCompare = (c2.lastUpdated ??
              DateTime.fromMillisecondsSinceEpoch(0))
          .compareTo(c1.lastUpdated ?? DateTime.fromMillisecondsSinceEpoch(0));
      if (updatedCompare != 0) return updatedCompare;

      // Priority 2: sort by name ascending
      return c1.name.compareTo(c2.name);
    });
  }
}
