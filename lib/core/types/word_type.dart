enum WordType {
  unspecified,
  noun,
  article,
  adjective,
  verb,
  adverb,
  preposition,
  interjection,
  conjunction,
  fixedConjunction, //todo rm and migrate data
  pronoun,
  numeral,

  phrase,
}

extension WordTypeExtension on WordType {
  String get label {
    switch (this) {
      case WordType.noun:
        return 'noun';
      case WordType.article:
        return 'article';
      case WordType.adjective:
        return 'adjective';
      case WordType.verb:
        return 'Verb';
      case WordType.adverb:
        return 'adverb';
      case WordType.preposition:
        return 'preposition';
      case WordType.interjection:
        return 'interjection';
      case WordType.conjunction:
        return 'conjunction';
      case WordType.fixedConjunction:
        return 'fixed conjunction';
      case WordType.pronoun:
        return 'pronoun';
      case WordType.numeral:
        return 'numeral';
      case WordType.phrase:
        return 'phrase';
      case WordType.unspecified:
        return 'unspecified';
    }
  }

  String get capitalLabel {
    switch (this) {
      case WordType.noun:
        return 'Noun';
      case WordType.article:
        return 'Article';
      case WordType.adjective:
        return 'Adjective';
      case WordType.verb:
        return 'Verb';
      case WordType.adverb:
        return 'Adverb';
      case WordType.preposition:
        return 'Preposition';
      case WordType.interjection:
        return 'Interjection';
      case WordType.conjunction:
        return 'Conjunction';
      case WordType.fixedConjunction:
        return 'Fixed Conjunction';
      case WordType.pronoun:
        return 'Pronoun';
      case WordType.numeral:
        return 'Numeral';
      case WordType.phrase:
        return 'Phrase';
      case WordType.unspecified:
        return 'Unspecified';
    }
  }
}
