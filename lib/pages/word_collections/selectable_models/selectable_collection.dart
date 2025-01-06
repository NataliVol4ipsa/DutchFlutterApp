import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';

class SelectableWordCollectionModel {
  bool isSelected = false;
  final int? id;
  final String name;
  final List<SelectableWordModel>? words;

  SelectableWordCollectionModel(this.id, this.name, this.words);
}
