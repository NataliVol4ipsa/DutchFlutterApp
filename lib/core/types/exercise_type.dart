enum ExerciseType {
  flipCard,
  basicWrite,
  deHetPick,
  pluralFormPick,
  pluralFormWrite,
  basicOnePick,
  basicManyPick,
}

extension ExerciseTypeExtension on ExerciseType {
  String get label {
    switch (this) {
      case ExerciseType.flipCard:
        return 'FlipCard Translation';
      case ExerciseType.basicWrite:
        return 'Translation Writing';
      case ExerciseType.deHetPick:
        return 'De or Het?';
      case ExerciseType.pluralFormPick:
        return 'Pick Plural Form';
      case ExerciseType.pluralFormWrite:
        return 'Write Plural Form';
      case ExerciseType.basicOnePick:
        return 'Pick Translation';
      case ExerciseType.basicManyPick:
        return 'Match Translations';
      default:
        return '';
    }
  }

  String get explanation {
    switch (this) {
      case ExerciseType.flipCard:
        return 'Simple mode where you flip the card and see whether your answer is correct';
      case ExerciseType.basicWrite:
        return 'Write Dutch translation of English word. (Phrases not included by default)';
      case ExerciseType.deHetPick:
        return 'For Dutch noun on the screen, select whether this word has de or her article';
      case ExerciseType.pluralFormPick:
        return 'For Dutch noun on the screen, select properly spelled plural form of the word from the list of options';
      case ExerciseType.pluralFormWrite:
        return 'For Dutch noun on the screen, write properly spelled plural form of the word';
      case ExerciseType.basicOnePick:
        return 'Pick translation of word on screen from list of options';
      case ExerciseType.basicManyPick:
        return 'Match two lists of words according to their translations';
      default:
        return '';
    }
  }
}
