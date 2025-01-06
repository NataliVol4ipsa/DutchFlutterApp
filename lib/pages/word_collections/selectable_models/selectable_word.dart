import 'package:dutch_app/core/models/word.dart';

class SelectableWordModel {
  bool isSelected = false;
  final Word word;

  SelectableWordModel(this.word);
}
