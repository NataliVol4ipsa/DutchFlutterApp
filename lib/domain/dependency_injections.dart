import 'package:dutch_app/core/local_db/repositories/word_progress_batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/words_import_repository.dart';
import 'package:dutch_app/domain/services/practice_session_stateful_service.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/services/batch_word_operations_service.dart';
import 'package:dutch_app/core/local_db/repositories/batch_repository.dart';
import 'package:dutch_app/core/local_db/repositories/settings_repository.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
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
        importRepository: context.read<WordsImportRepository>(),
        batchRepository: context.read<BatchRepository>(),
      ),
    ),
    Provider<PracticeSessionStatefulService>(
      create: (context) => PracticeSessionStatefulService(),
    ),
    Provider<WordProgressService>(
      create: (context) => WordProgressService(
        wordProgressRepository: context.read<WordProgressBatchRepository>(),
      ),
    ),
  ];
}
