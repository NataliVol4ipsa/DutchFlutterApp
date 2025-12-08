class Settings {
  final ThemeSettings theme;
  final SessionSettings session;

  Settings({required this.theme, required this.session});
}

class ThemeSettings {
  bool useSystemMode;
  bool useDarkMode;

  ThemeSettings({bool? useSystemMode, bool? useDarkMode})
    : useSystemMode = useSystemMode ?? true,
      useDarkMode = useDarkMode ?? false;
}

class SessionSettings {
  int newWordsPerSession;
  int repetitionsPerSession;
  SessionSettings({int? newWordsPerSession, int? repetitionsPerSession})
    : newWordsPerSession = newWordsPerSession ?? 5,
      repetitionsPerSession = repetitionsPerSession ?? 20;
}
