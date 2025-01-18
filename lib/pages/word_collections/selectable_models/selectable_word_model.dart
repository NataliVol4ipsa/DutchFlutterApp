import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/core/types/de_het_type.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_item_model.dart';

class SelectableWordModel implements SelectableItemModel<Word> {
  @override
  bool isSelected = false;

  @override
  final Word value;

  @override
  late String displayValue;

  SelectableWordModel(this.value) {
    var dutchWord = value.deHetType != DeHetType.none
        ? "${value.deHetType.label} ${value.dutchWord}"
        : value.dutchWord;
    displayValue = "$dutchWord - ${value.englishWord}";
  }

  void toggleIsSelected() {
    isSelected = !isSelected;
  }
}
