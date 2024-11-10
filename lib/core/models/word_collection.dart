import 'package:first_project/core/models/word.dart';

class WordCollection {
  final int? id;
  final String name;
  final List<Word>? words;

  WordCollection(this.id, this.name, {this.words});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is WordCollection && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
