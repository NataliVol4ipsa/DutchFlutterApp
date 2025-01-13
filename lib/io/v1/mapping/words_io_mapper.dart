import 'package:dutch_app/core/models/new_word.dart';
import 'package:dutch_app/core/models/word_collection.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/core/types/word_type.dart';
import 'package:dutch_app/io/v1/models/export_package_v1.dart';

class WordsIoMapper {
  static ExportPackageV1 toExportPackageV1(List<WordCollection> collections) {
    return ExportPackageV1(collections
        .map((collection) => ExportWordCollectionV1.fromCollection(collection))
        .toList());
  }

  static NewWord toNewWord(ExportWordV1 source) {
    if (source.dutchWord == null) {
      throw Exception("Cannot create word without dutchWord");
    }
    if (source.englishWord == null) {
      throw Exception("Cannot create word without englishWord");
    }
    var wordType = source.wordType ?? WordType.none;
    var deHetType = source.deHetType ?? DeHetType.none;
    return NewWord(source.dutchWord!, source.englishWord!, wordType,
        deHetType: deHetType, pluralForm: source.pluralForm, tag: source.tag);
  }

  static List<NewWord> toNewWordsListV1(ExportWordCollectionV1 collection) {
    return collection.words.map((wordDto) => toNewWord(wordDto)).toList();
  }
}
