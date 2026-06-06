import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:dutch_app/core/audio/audio_config.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

/// Outcome of attempting to (re)download a word's audio.
enum AudioDownloadStatus {
  /// A new audio file was downloaded and cached for the first time.
  added,

  /// An existing cached audio file was replaced with a freshly downloaded one.
  updated,

  /// The remote storage has no audio for this word (e.g. 404).
  missing,

  /// The download failed for another reason (network error, not configured...).
  failed,
}

/// Handles reading, caching, downloading and clearing of word audio files.
///
/// Audio is stored in Azure Blob Storage. The container URL (including the SAS
/// token) is provided as a developer secret via [AudioConfig]. The blob name is
/// the lowercased Dutch word followed by `.mp3`, inserted into the container
/// URL path before the SAS query string. Blob names are percent-encoded so that
/// spaces, dashes and Dutch special characters (e.g. the "é" in "één") are
/// handled correctly.
class WordAudioService {
  static const String _cacheDirectoryName = 'audio_cache';

  static Future<Directory> _getOrCreateCacheDirectory() async {
    final directory = await getApplicationDocumentsDirectory();
    final cacheDirectory = Directory('${directory.path}/$_cacheDirectoryName');
    if (!await cacheDirectory.exists()) {
      await cacheDirectory.create(recursive: true);
    }
    return cacheDirectory;
  }

  static String _cacheFileName(String word) {
    return '${Uri.encodeComponent(word.trim().toLowerCase())}.mp3';
  }

  static Future<File> _cacheFileFor(String word) async {
    final cacheDirectory = await _getOrCreateCacheDirectory();
    return File('${cacheDirectory.path}/${_cacheFileName(word)}');
  }

  static Uri _buildWordUrl(String word) {
    final sasUrl = AudioConfig.audioContainerSasUrl.trim();
    final queryIndex = sasUrl.indexOf('?');
    final base = queryIndex == -1 ? sasUrl : sasUrl.substring(0, queryIndex);
    final query = queryIndex == -1 ? '' : sasUrl.substring(queryIndex);
    final blobName = Uri.encodeComponent('${word.trim().toLowerCase()}.mp3');
    return Uri.parse('$base/$blobName$query');
  }

  static Future<bool> hasCachedAudio(String word) async {
    final file = await _cacheFileFor(word);
    return file.exists();
  }

  static Future<int> getCacheSizeBytes() async {
    final cacheDirectory = await _getOrCreateCacheDirectory();
    if (!await cacheDirectory.exists()) return 0;
    int total = 0;
    await for (final entity in cacheDirectory.list(recursive: true)) {
      if (entity is File) {
        total += await entity.length();
      }
    }
    return total;
  }

  static String formatCacheSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static Future<void> playCachedOrUrl(String word) async {
    final file = await _cacheFileFor(word);

    if (!await file.exists()) {
      final status = await downloadAudio(word);
      if (status != AudioDownloadStatus.added &&
          status != AudioDownloadStatus.updated) {
        throw Exception('Failed to load audio for word: $word');
      }
    }

    final player = AudioPlayer();
    player.onPlayerComplete.listen((_) => player.dispose());
    await player.play(DeviceFileSource(file.path));
  }

  static Future<AudioDownloadStatus> downloadAudio(String word) async {
    if (!AudioConfig.isConfigured) {
      return AudioDownloadStatus.failed;
    }

    final file = await _cacheFileFor(word);
    final existedBefore = await file.exists();

    try {
      final response = await http.get(_buildWordUrl(word));

      if (response.statusCode == 404) {
        return AudioDownloadStatus.missing;
      }
      if (response.statusCode != 200) {
        return AudioDownloadStatus.failed;
      }

      await file.writeAsBytes(response.bodyBytes);
      return existedBefore
          ? AudioDownloadStatus.updated
          : AudioDownloadStatus.added;
    } catch (_) {
      return AudioDownloadStatus.failed;
    }
  }

  static Future<void> clearCache() async {
    final cacheDirectory = await _getOrCreateCacheDirectory();
    if (await cacheDirectory.exists()) {
      await cacheDirectory.delete(recursive: true);
    }
  }
}
