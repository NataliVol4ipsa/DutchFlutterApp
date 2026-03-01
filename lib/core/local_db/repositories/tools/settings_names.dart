class SettingsNames {
  static ThemeSettingsNames theme = ThemeSettingsNames();
  static SessionSettingsNames session = SessionSettingsNames();
  static ExtraPracticeSettingsNames extraPractice =
      ExtraPracticeSettingsNames();
}

class ThemeSettingsNames {
  final String useSystemModeBool = "useSystemMode";
  final String useDarkModeBool = "useDarkMode";
}

class SessionSettingsNames {
  final String newWordsPerSessionInt = "newWordsPerSession";
  final String repetitionsPerSessionInt = "repetitionsPerSession";
  final String useAnkiModeBool = "useAnkiMode";
  final String showPreSessionWordListBool = "showPreSessionWordList";
  final String includePhrasesInWritingBool = "includePhrasesInWriting";
}

class ExtraPracticeSettingsNames {
  final String useWeakestWordsBool = "extraPractice.useWeakestWords";
  final String useTomorrowsWordsBool = "extraPractice.useTomorrowsWords";
  final String useRecentlyLearnedBool = "extraPractice.useRecentlyLearned";
  final String useRandomWordsBool = "extraPractice.useRandomWords";
}
