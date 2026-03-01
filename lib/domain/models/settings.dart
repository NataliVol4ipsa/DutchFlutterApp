class Settings {
  final ThemeSettings theme;
  final SessionSettings session;
  final ExtraPracticeSettings extraPractice;

  Settings({
    required this.theme,
    required this.session,
    ExtraPracticeSettings? extraPractice,
  }) : extraPractice = extraPractice ?? ExtraPracticeSettings();
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

class ExtraPracticeSettings {
  bool useWeakestWords;
  bool useTomorrowsWords;
  bool useRecentlyLearned;
  bool useRandomWords;

  ExtraPracticeSettings({
    bool? useWeakestWords,
    bool? useTomorrowsWords,
    bool? useRecentlyLearned,
    bool? useRandomWords,
  }) : useWeakestWords = useWeakestWords ?? true,
       useTomorrowsWords = useTomorrowsWords ?? true,
       useRecentlyLearned = useRecentlyLearned ?? false,
       useRandomWords = useRandomWords ?? false;

  bool get hasAnySelected =>
      useWeakestWords ||
      useTomorrowsWords ||
      useRecentlyLearned ||
      useRandomWords;

  Map<ExtraPracticeBucket, double> get normalizedWeights {
    const rawWeights = {
      ExtraPracticeBucket.weakest: 0.50,
      ExtraPracticeBucket.tomorrow: 0.25,
      ExtraPracticeBucket.recentlyLearned: 0.15,
      ExtraPracticeBucket.random: 0.10,
    };
    final activeBuckets = [
      if (useWeakestWords) ExtraPracticeBucket.weakest,
      if (useTomorrowsWords) ExtraPracticeBucket.tomorrow,
      if (useRecentlyLearned) ExtraPracticeBucket.recentlyLearned,
      if (useRandomWords) ExtraPracticeBucket.random,
    ];
    if (activeBuckets.isEmpty) return {};
    final totalWeight = activeBuckets.fold(
      0.0,
      (sum, b) => sum + rawWeights[b]!,
    );
    return {for (final b in activeBuckets) b: rawWeights[b]! / totalWeight};
  }
}

enum ExtraPracticeBucket { weakest, tomorrow, recentlyLearned, random }
