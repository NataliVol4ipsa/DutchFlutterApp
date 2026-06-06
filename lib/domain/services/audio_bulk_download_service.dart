import 'package:dutch_app/core/audio/audio_config.dart';
import 'package:dutch_app/core/audio/word_audio_service.dart';
import 'package:dutch_app/core/local_db/repositories/words_repository.dart';

enum AudioBulkDownloadPhase { preparing, downloading, done }

enum AudioDownloadMode { missingOnly, updateExisting }

class AudioBulkDownloadResult {
  final List<String> added;
  final List<String> updated;
  final List<String> missing;

  const AudioBulkDownloadResult({
    required this.added,
    required this.updated,
    required this.missing,
  });
}

class AudioBulkDownloadService {
  static const int _concurrency = 6;

  final WordsRepository wordsRepository;

  AudioBulkDownloadService(this.wordsRepository);

  static bool get isConfigured => AudioConfig.isConfigured;

  /// Returns the words to process for the given [mode]:
  /// - [AudioDownloadMode.missingOnly]: words without a cached audio file.
  /// - [AudioDownloadMode.updateExisting]: words that already have a cached file.
  Future<List<String>> getWordsForModeAsync(AudioDownloadMode mode) async {
    final allWords = await wordsRepository.getAllAddedDutchWordsAsync();
    final result = <String>[];
    for (final word in allWords) {
      final cached = await WordAudioService.hasCachedAudio(word);
      if (mode == AudioDownloadMode.missingOnly ? !cached : cached) {
        result.add(word);
      }
    }
    return result;
  }

  /// Downloads (or refreshes) the audio for every word in [words], calling
  /// [onProgress] after each individual download completes.
  Future<AudioBulkDownloadResult> downloadAllAsync({
    required List<String> words,
    required void Function(int done, int total) onProgress,
    required bool Function() isCancelled,
  }) async {
    final added = <String>[];
    final updated = <String>[];
    final missing = <String>[];
    int done = 0;
    var index = 0;

    Future<void> worker() async {
      while (true) {
        if (isCancelled()) return;
        final int current = index++;
        if (current >= words.length) return;

        final word = words[current];
        final status = await WordAudioService.downloadAudio(word);

        if (isCancelled()) return;

        switch (status) {
          case AudioDownloadStatus.added:
            added.add(word);
            break;
          case AudioDownloadStatus.updated:
            updated.add(word);
            break;
          case AudioDownloadStatus.missing:
          case AudioDownloadStatus.failed:
            missing.add(word);
            break;
        }

        done++;
        onProgress(done, words.length);
      }
    }

    final workerCount = words.length < _concurrency
        ? words.length
        : _concurrency;
    if (workerCount > 0) {
      await Future.wait(List.generate(workerCount, (_) => worker()));
    }

    return AudioBulkDownloadResult(
      added: added,
      updated: updated,
      missing: missing,
    );
  }
}
