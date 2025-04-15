import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_string_model.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word_model.dart';

class SelectableWordCollectionModel {
  bool isSelected = false;
  SelectableStringModel? selectAllModel;
  final int id;
  final String name;
  final List<SelectableWordModel>? words;
  final DateTime? lastUpdated;

  SelectableWordCollectionModel(this.id, this.name, this.words,
      {this.lastUpdated}) {
    if (words != null && words!.isNotEmpty) {
      selectAllModel = SelectableStringModel("Select all");
    }
  }

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
        result.add(words![i].value);
      }
    }

    return result;
  }

  void toggleIsSelectedCollectionAndWords() {
    isSelected = !isSelected;
    if (words != null) {
      for (var word in words!) {
        word.isSelected = isSelected;
      }
    }
  }
}
