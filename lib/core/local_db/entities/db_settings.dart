import 'package:dutch_app/domain/types/setting_value_type.dart';
import 'package:isar/isar.dart';

part 'db_settings.g.dart';

@Collection()
class DbSettings {
  Id id = Isar.autoIncrement;
  @Index(unique: true)
  late String key;
  late String value;
  @enumerated
  late SettingValueType valueType;
}
