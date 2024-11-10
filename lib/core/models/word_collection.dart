import 'package:first_project/core/models/word.dart';

class WordCollection {
  final int? id;
  final String name;
  final List<Word>? words;

  WordCollection(this.id, this.name, {this.words});
}
