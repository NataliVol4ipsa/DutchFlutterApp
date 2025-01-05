import 'package:dutch_app/core/types/setting_value_type.dart';
import 'package:dutch_app/local_db/db_context.dart';
import 'package:dutch_app/local_db/entities/db_settings.dart';
import 'package:isar/isar.dart';

class SettingsRepository {
  Future<List<DbSettings>> getAllKeyValuesAsync() async {
    return await DbContext.isar.dbSettings.where().findAll();
  }

  Future<int> addAsync(String key, String value, SettingValueType type) async {
    final newSetting = DbSettings();
    newSetting.key = key;
    newSetting.value = value;
    newSetting.valueType = type;

    final int id = await DbContext.isar
        .writeTxn(() => DbContext.isar.dbSettings.put(newSetting));
    return id;
  }

  Future<bool> updateAsync(String key, String newValue) async {
    final DbSettings? dbSetting =
        await DbContext.isar.dbSettings.filter().keyEqualTo(key).findFirst();

    if (dbSetting == null) {
      return false;
    }

    dbSetting.value = newValue;

    await DbContext.isar
        .writeTxn(() => DbContext.isar.dbSettings.put(dbSetting));

    return true;
  }

  Future<bool> deleteAsync(String key) async {
    final DbSettings? dbSetting =
        await DbContext.isar.dbSettings.filter().keyEqualTo(key).findFirst();

    if (dbSetting == null) {
      throw Exception(
          "Tried to delete setting $key, but it was not found in database.");
    }

    return await DbContext.isar
        .writeTxn(() => DbContext.isar.dbSettings.delete(dbSetting.id));
  }
}
