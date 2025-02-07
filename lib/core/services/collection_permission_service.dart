class CollectionPermissionService {
  static int defaultCollectionId = -1;
  static const String defaultCollectionName = "Default collection";

  static bool canCreateCollection(String? collectionName) {
    if (collectionName == null) {
      return false;
    }

    if (isDefaultCollectionName(collectionName)) {
      return false;
    }

    collectionName = collectionName.trim();
    if (collectionName == "") {
      return false;
    }

    return true;
  }

  static bool isDefaultCollectionName(String collectionName) {
    return collectionName.trim().toLowerCase() ==
        CollectionPermissionService.defaultCollectionName.toLowerCase();
  }

  static bool canRenameCollection(int collectionIdToRename) {
    return collectionIdToRename != defaultCollectionId;
  }

  static bool canRenameCollectionIntoName(String? newCollectionName) {
    return canCreateCollection(newCollectionName);
  }
}
