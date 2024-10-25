enum LearningModeType { dutchEnglish, englishDutch }

extension LearningModeTypeExtension on LearningModeType {
  String get label {
    switch (this) {
      case LearningModeType.dutchEnglish:
        return 'Dutch-English';
      case LearningModeType.englishDutch:
        return 'English-Dutch';
      default:
        return '';
    }
  }
}
