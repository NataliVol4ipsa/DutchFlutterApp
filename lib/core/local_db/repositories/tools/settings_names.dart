class SettingsNames {
  static ThemeSettingsNames theme = ThemeSettingsNames();
  static SessionSettingsNames session = SessionSettingsNames();
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
}
