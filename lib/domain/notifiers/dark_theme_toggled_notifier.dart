import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:flutter/material.dart';

class DarkThemeToggledNotifier extends ChangeNotifier {
  bool _isDarkTheme = false;

  bool get isDarkTheme => _isDarkTheme;

  ThemeMode get currentTheme => _isDarkTheme ? ThemeMode.dark : ThemeMode.light;

  Future<void> loadInitialTheme(
      SettingsService settingsService, Brightness platformBrightness) async {
    var settings = await settingsService.getSettingsAsync();

    _isDarkTheme = shouldUseDarkTheme(settings.theme.useSystemMode,
        settings.theme.useDarkMode, platformBrightness);

    notifyListeners();
  }

  static bool shouldUseDarkTheme(
      bool useSystemMode, bool useDarkMode, Brightness systemMode) {
    if (useSystemMode) {
      return systemMode == Brightness.dark;
    } else {
      return useDarkMode;
    }
  }

  void setDarkTheme(bool useDarkTheme) {
    _isDarkTheme = useDarkTheme;
    notifyListeners();
  }
}
