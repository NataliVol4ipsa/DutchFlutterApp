import 'package:dutch_app/core/models/new_word.dart';

class NewWordCollection {
  final String name;
  final List<NewWord> words;
  NewWordCollection(this.name, {this.words = const []});
}
