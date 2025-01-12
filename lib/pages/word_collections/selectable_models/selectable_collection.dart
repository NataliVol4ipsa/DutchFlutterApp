import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';

class SelectableWordCollectionModel {
  bool isSelected = false;
  final int? id;
  final String name;
  final List<SelectableWordModel>? words;

  SelectableWordCollectionModel(this.id, this.name, this.words);

  bool containsSelectedWords() {
    if (words == null) {
      return false;
    }

    for (int i = 0; i < words!.length; i++) {
      if (words![i].isSelected) return true;
    }

    return false;
  }

  List<Word> getSelectedWords() {
    if (words == null) {
      return [];
    }

    List<Word> result = [];
    for (int i = 0; i < words!.length; i++) {
      if (words![i].isSelected) {
        result.add(words![i].word);
      }
    }

    return result;
  }
}
