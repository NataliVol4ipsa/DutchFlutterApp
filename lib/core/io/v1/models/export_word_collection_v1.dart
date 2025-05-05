import 'package:dutch_app/core/io/v1/models/export_word_v1.dart';
import 'package:dutch_app/domain/models/word_collection.dart';

class ExportWordCollectionV1 {
  final List<ExportWordV1> words;
  final String name;

  ExportWordCollectionV1(this.words, this.name);

  ExportWordCollectionV1.fromCollection(WordCollection source)
      : name = source.name,
        words =
            source.words!.map((word) => ExportWordV1.fromWord(word)).toList();

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'words': words.map((word) => word.toJson()).toList(),
    };
  }

  factory ExportWordCollectionV1.fromJson(Map<String, dynamic> json) {
    var wordsList = (json['words'] as List)
        .map((wordJson) => ExportWordV1.fromJson(wordJson))
        .toList();

    var name = json['name'] as String;

    return ExportWordCollectionV1(wordsList, name);
  }
}
