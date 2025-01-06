import 'package:dutch_app/pages/word_collections/selectable_models/selectable_word.dart';

class SelectableWordCollection {
  bool isSelected = false;
  final int? id;
  final String name;
  final List<SelectableWord>? words;

  SelectableWordCollection(this.id, this.name, this.words);
}
