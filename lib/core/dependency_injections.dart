import 'package:dutch_app/core/services/practice_session_stateful_service.dart';
import 'package:dutch_app/core/services/settings_service.dart';
import 'package:dutch_app/core/services/batch_word_operations_service.dart';
import 'package:dutch_app/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/local_db/repositories/settings_repository.dart';
import 'package:provider/provider.dart';

List<Provider> serviceProviders() {
  return [
    Provider<SettingsService>(
      create: (context) => SettingsService(
        settingsRepository: context.read<SettingsRepository>(),
      ),
    ),
    Provider<BatchWordOperationsService>(
      create: (context) => BatchWordOperationsService(
        batchRepository: context.read<BatchRepository>(),
      ),
    ),
    Provider<PracticeSessionStatefulService>(
      create: (context) => PracticeSessionStatefulService(),
    ),
  ];
}
