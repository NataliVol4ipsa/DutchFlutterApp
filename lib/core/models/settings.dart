class Settings {
  final ThemeSettings theme;

  Settings({required this.theme});
}

class ThemeSettings {
  bool useSystemMode;
  bool useDarkMode;

  ThemeSettings({
    bool? useSystemMode,
    bool? useDarkMode,
  })  : useSystemMode = useSystemMode ?? true,
        useDarkMode = useDarkMode ?? false;
}
