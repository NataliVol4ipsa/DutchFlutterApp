import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/services/audio_bulk_download_service.dart';
import 'package:dutch_app/pages/settings/settings_pages/audio_download_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showDownloadMissingAudiosDialog(BuildContext context) =>
    _showDialog(context, AudioDownloadMode.missingOnly);

Future<void> showUpdateExistingAudiosDialog(BuildContext context) =>
    _showDialog(context, AudioDownloadMode.updateExisting);

Future<void> _showDialog(BuildContext context, AudioDownloadMode mode) {
  if (!AudioBulkDownloadService.isConfigured) return Future.value();

  final service = AudioBulkDownloadService(context.read<WordsRepository>());
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => AudioDownloadDialog(service: service, mode: mode),
  );
}
