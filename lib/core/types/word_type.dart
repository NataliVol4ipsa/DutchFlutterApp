enum WordType {
  unspecified,
  noun,
  adjective,
  verb,
  adverb,
  preposition,
  interjection,
  conjuction,
  fixedConjuction,
  pronoun,
  numeral,

  phrase,
}

extension WordTypeExtension on WordType {
  String get label {
    switch (this) {
      case WordType.noun:
        return 'noun';
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
      case WordType.conjuction:
        return 'conjuction';
      case WordType.fixedConjuction:
        return 'fixed conjuction';
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
      case WordType.conjuction:
        return 'Conjuction';
      case WordType.fixedConjuction:
        return 'Fixed Conjuction';
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
