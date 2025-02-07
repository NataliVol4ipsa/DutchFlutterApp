import 'package:dutch_app/local_db/seed/db_seed.dart';

bool isValidCollectionName(String? name) {
  if (name == null) {
    return false;
  }

  name = name.trim();

  if (name.toLowerCase() ==
      CollectionsConfig.defaultCollectionName.toLowerCase()) {
    return false;
  }

  if (name == "") {
    return false;
  }

  return true;
}
