import 'package:dutch_app/core/io/v1/models/export_word_collection_v1.dart';

class ExportPackageV1 {
  final List<ExportWordCollectionV1> collections;

  ExportPackageV1(this.collections);

  Map<String, dynamic> toJson() {
    return {
      'collections':
          collections.map((collection) => collection.toJson()).toList(),
    };
  }

  factory ExportPackageV1.fromJson(Map<String, dynamic> json) {
    var collections = (json['collections'] as List)
        .map(
            (collectionJson) => ExportWordCollectionV1.fromJson(collectionJson))
        .toList();

    return ExportPackageV1(collections);
  }
}
