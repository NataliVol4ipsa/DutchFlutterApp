import 'package:dutch_app/pages/word_collections/selectable_models/selectable_item_model.dart';

class SelectableStringModel implements SelectableItemModel<String> {
  @override
  bool isSelected = false;

  @override
  final String value;

  @override
  late String displayValue;

  SelectableStringModel(this.value) {
    displayValue = value;
  }
}
