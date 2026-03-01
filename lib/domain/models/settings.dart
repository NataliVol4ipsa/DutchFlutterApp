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
  bool useAnkiMode;
  bool showPreSessionWordList;
  bool includePhrasesInWriting;

  SessionSettings({
    int? newWordsPerSession,
    int? repetitionsPerSession,
    bool? useAnkiMode,
    bool? showPreSessionWordList,
    bool? includePhrasesInWriting,
  }) : newWordsPerSession = newWordsPerSession ?? 5,
       repetitionsPerSession = repetitionsPerSession ?? 20,
       useAnkiMode = useAnkiMode ?? false,
       showPreSessionWordList = showPreSessionWordList ?? true,
       includePhrasesInWriting = includePhrasesInWriting ?? false;
}
