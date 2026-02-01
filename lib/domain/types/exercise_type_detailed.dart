enum ExerciseTypeDetailed {
  flipCardDutchEnglish,
  flipCardEnglishDutch,
  deHetPick,
}

extension ExerciseTypeDetailedExtension on ExerciseTypeDetailed {
  String get label {
    switch (this) {
      case ExerciseTypeDetailed.flipCardDutchEnglish:
        return 'FlipCard Dutch-English';
      case ExerciseTypeDetailed.flipCardEnglishDutch:
        return 'FlipCard English-Dutch';
      case ExerciseTypeDetailed.deHetPick:
        return 'De or Het?';
    }
  }

  String get explanation {
    switch (this) {
      case ExerciseTypeDetailed.flipCardDutchEnglish:
        return 'Simple mode where you flip the card and see whether your answer is correct. Dutch to English';
      case ExerciseTypeDetailed.flipCardEnglishDutch:
        return 'Simple mode where you flip the card and see whether your answer is correct. English to Dutch';
      case ExerciseTypeDetailed.deHetPick:
        return 'For Dutch noun, choose whether word has de or her article';
    }
  }
}
