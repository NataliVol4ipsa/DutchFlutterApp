import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/types/setting_value_type.dart';
import 'package:dutch_app/core/local_db/entities/db_settings.dart';
import 'package:dutch_app/core/local_db/repositories/settings_repository.dart';
import 'package:collection/collection.dart';
import 'package:dutch_app/core/local_db/repositories/tools/settings_names.dart';

class SettingsService {
  final SettingsRepository settingsRepository;

  SettingsService({required this.settingsRepository});

  static final Map<Type, String Function(dynamic)> typeToStringConverters = {
    bool: (value) => value.toString(),
    int: (value) => value.toString(),
    String: (value) => value,
  };

  static final Map<String, bool Function(Settings)> propertyGetters = {
    SettingsNames.theme.useSystemModeBool: (Settings s) =>
        s.theme.useSystemMode,
    SettingsNames.theme.useDarkModeBool: (Settings s) => s.theme.useDarkMode,
  };

  Future<Settings> getSettingsAsync() async {
    List<DbSettings> keyValues =
        await settingsRepository.getAllKeyValuesAsync();

    return Settings(
        theme: ThemeSettings(
      useSystemMode: _getBool(keyValues, SettingsNames.theme.useSystemModeBool),
      useDarkMode: _getBool(keyValues, SettingsNames.theme.useDarkModeBool),
    ));
  }

  Future<Settings> updateSettingsAsync(Settings newSettings) async {
    Settings oldSettings = await getSettingsAsync();

    for (var entry in propertyGetters.entries) {
      final String key = entry.key;
      final bool Function(Settings) getter = entry.value;

      final bool oldValue = getter(oldSettings);
      final bool newValue = getter(newSettings);

      if (oldValue != newValue) {
        final Type valueType = newValue.runtimeType;

        final converter = typeToStringConverters[valueType];
        if (converter != null) {
          final stringValue = converter(newValue);
          await _updateValueAsync(key, stringValue);
        } else {
          throw UnsupportedError(
              "Failed to update settings. No converter found for type: $valueType");
        }
      }
    }

    return await getSettingsAsync();
  }

  bool? _getBool(List<DbSettings> settings, String key) {
    final DbSettings? dbSetting = settings.firstWhereOrNull(
      (setting) => setting.key == key,
    );

    if (dbSetting != null) {
      return dbSetting.value.toLowerCase() == 'true';
    }

    return null;
  }

  Future<void> _updateValueAsync(String key, String value) async {
    if (!await settingsRepository.updateAsync(key, value)) {
      await settingsRepository.addAsync(key, value, SettingValueType.bool);
    }
  }
}
