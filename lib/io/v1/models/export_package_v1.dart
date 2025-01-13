import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';

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

class ExportWordV1 {
  String? dutchWord;
  String? englishWord;
  WordType? wordType;
  DeHetType? deHetType = DeHetType.none;
  String? pluralForm;
  String? tag;
  String? comment;

  ExportWordV1(
    this.dutchWord,
    this.englishWord,
    this.wordType, {
    this.deHetType = DeHetType.none,
    this.pluralForm,
    this.tag,
    this.comment,
  });

  ExportWordV1.fromWord(Word source)
      : dutchWord = source.dutchWord,
        englishWord = source.englishWord,
        wordType = source.wordType,
        deHetType = source.deHetType,
        pluralForm = source.pluralForm,
        tag = source.tag;

  ExportWordV1.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWord = json['englishWord'] as String,
        wordType =
            WordType.values.firstWhere((e) => e.toString() == json['type']),
        deHetType =
            DeHetType.values.firstWhere((e) => e.toString() == json['deHet']),
        pluralForm = json['pluralForm'] as String?,
        tag = json['tag'] as String?,
        comment = json['comment'] as String?;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWord': englishWord,
        'type': wordType.toString(),
        'deHet': deHetType.toString(),
        'pluralForm': pluralForm,
        'tag': tag,
        'comment': comment,
      };
}
