class Word {
  final String dutchWord;
  final String englishWord;
  final WordType type;
  final bool isPhrase;
  DeHetType? deHet;
  String? pluralForm;
  String? tag;

  Word(this.dutchWord, this.englishWord, this.type, this.isPhrase);

  Word.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWord = json['englishWord'] as String,
        type = json['type'] as WordType,
        isPhrase = json['isPhrase'] as bool,
        deHet = json['deHet'] as DeHetType,
        pluralForm = json['pluralForm'] as String,
        tag = json['tag'] as String;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWord': englishWord,
        'type': type,
        'isPhrase': isPhrase,
        'deHet': deHet,
        'pluralForm': pluralForm,
        'tag': tag,
      };
}

class WordList {}

enum WordType {
  noun,
  adjective,
  verb,
}

enum DeHetType { de, het }
