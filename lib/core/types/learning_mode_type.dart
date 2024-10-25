enum LearningModeType {
  flipCard,
  basicWrite,
  deHetPick,
  pluralFormPick,
  pluralFormWrite,
  basicOnePick,
  basicManyPick,
}

extension LearningModeTypeExtension on LearningModeType {
  String get label {
    switch (this) {
      case LearningModeType.flipCard:
        return 'FlipCard Translation';
      case LearningModeType.basicWrite:
        return 'Translation Writing';
      case LearningModeType.deHetPick:
        return 'De or Het?';
      case LearningModeType.pluralFormPick:
        return 'Pick Plural Form';
      case LearningModeType.pluralFormWrite:
        return 'Write Plural Form';
      case LearningModeType.basicOnePick:
        return 'Pick Translation';
      case LearningModeType.basicManyPick:
        return 'Match Translations';
      default:
        return '';
    }
  }

  String get explanation {
    switch (this) {
      case LearningModeType.flipCard:
        return 'Simple mode where you see one word and need to translate it';
      case LearningModeType.basicWrite:
        return 'Write Dutch translation of English word';
      case LearningModeType.deHetPick:
        return 'For Dutch noun on the screen, select whether this word has de or her article';
      case LearningModeType.pluralFormPick:
        return 'For Dutch noun on the screen, select properly spelled plural form of the word from the list of options';
      case LearningModeType.pluralFormWrite:
        return 'For Dutch noun on the screen, write properly spelled plural form of the word';
      case LearningModeType.basicOnePick:
        return 'Pick translation of word on screen from list of options';
      case LearningModeType.basicManyPick:
        return 'Match two lists of words according to their translations';
      default:
        return '';
    }
  }
}
