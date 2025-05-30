import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/pages/word_collections/selectable_models/selectable_item_model.dart';

class SelectableWordModel implements SelectableItemModel<Word> {
  @override
  bool isSelected = false;
  bool isVisible = true;

  @override
  final Word value;

  @override
  late String displayValue;

  SelectableWordModel(this.value) {
    displayValue =
        "${value.dutchWord} - ${SemicolonWordsConverter.toSingleString(value.englishWords)}";
  }

  void toggleIsSelected() {
    isSelected = !isSelected;
  }
}
