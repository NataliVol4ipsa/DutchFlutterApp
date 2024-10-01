class Word {
  final String dutchWord;
  final String englishWord;
  final WordType type;
  final bool isPhrase;
  DeHetType? deHet;
  String? pluralForm;

  Word(this.dutchWord, this.englishWord, this.type, this.isPhrase);

  Word.fromJson(Map<String, dynamic> json)
      : dutchWord = json['dutchWord'] as String,
        englishWord = json['englishWord'] as String,
        type = json['type'] as WordType,
        isPhrase = json['isPhrase'] as bool,
        deHet = json['deHet'] as DeHetType,
        pluralForm = json['pluralForm'] as String;

  Map<String, dynamic> toJson() => {
        'dutchWord': dutchWord,
        'englishWord': englishWord,
        'type': type,
        'isPhrase': isPhrase,
      };
}

enum WordType {
  noun,
  adjective,
  verb,
}

enum DeHetType { de, het }
