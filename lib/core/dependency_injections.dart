import 'package:dutch_app/core/services/settings_service.dart';
import 'package:dutch_app/local_db/repositories/settings_repository.dart';
import 'package:provider/provider.dart';

List<Provider> serviceProviders() {
  return [
    Provider<SettingsService>(
      create: (context) => SettingsService(
        settingsRepository: context.read<SettingsRepository>(),
      ),
    ),
  ];
}
