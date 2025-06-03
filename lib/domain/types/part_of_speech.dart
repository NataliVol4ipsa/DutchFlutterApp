enum PartOfSpeech {
  unspecified,
  noun,
  adjective,
  verb,
  adverb,
  preposition,
  interjection,
  conjunction,
  fixedConjunction, //todo rm and migrate data DO NOT REMOVE MINDLESSLY BECAUE IT WILL BREAK DB
  pronoun,
  numeral,

  phrase,
  article,
}

extension PartOfSpeechExtension on PartOfSpeech {
  String get label {
    switch (this) {
      case PartOfSpeech.noun:
        return 'noun';
      case PartOfSpeech.article:
        return 'article';
      case PartOfSpeech.adjective:
        return 'adjective';
      case PartOfSpeech.verb:
        return 'Verb';
      case PartOfSpeech.adverb:
        return 'adverb';
      case PartOfSpeech.preposition:
        return 'preposition';
      case PartOfSpeech.interjection:
        return 'interjection';
      case PartOfSpeech.conjunction:
        return 'conjunction';
      case PartOfSpeech.fixedConjunction:
        return 'fixed conjunction';
      case PartOfSpeech.pronoun:
        return 'pronoun';
      case PartOfSpeech.numeral:
        return 'numeral';
      case PartOfSpeech.phrase:
        return 'phrase';
      case PartOfSpeech.unspecified:
        return 'unspecified';
    }
  }

  String get capitalLabel {
    switch (this) {
      case PartOfSpeech.noun:
        return 'Noun';
      case PartOfSpeech.article:
        return 'Article';
      case PartOfSpeech.adjective:
        return 'Adjective';
      case PartOfSpeech.verb:
        return 'Verb';
      case PartOfSpeech.adverb:
        return 'Adverb';
      case PartOfSpeech.preposition:
        return 'Preposition';
      case PartOfSpeech.interjection:
        return 'Interjection';
      case PartOfSpeech.conjunction:
        return 'Conjunction';
      case PartOfSpeech.fixedConjunction:
        return 'Fixed Conjunction';
      case PartOfSpeech.pronoun:
        return 'Pronoun';
      case PartOfSpeech.numeral:
        return 'Numeral';
      case PartOfSpeech.phrase:
        return 'Phrase';
      case PartOfSpeech.unspecified:
        return 'Unspecified';
    }
  }
}
