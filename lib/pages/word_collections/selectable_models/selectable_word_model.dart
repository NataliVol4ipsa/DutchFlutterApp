import 'package:dutch_app/core/models/word.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_item_model.dart';

class SelectableWordModel implements SelectableItemModel<Word> {
  @override
  bool isSelected = false;

  @override
  final Word value;

  @override
  late String displayValue;

  SelectableWordModel(this.value) {
    displayValue = "${value.toDutchWordString()} - ${value.englishWord}";
  }

  void toggleIsSelected() {
    isSelected = !isSelected;
  }
}
