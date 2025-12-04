import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<Directory> _getOrCreateCacheDirectory(String audioCode) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final cacheDirectory = Directory(
    '${directory.path}/${audioCode[0]}/$audioCode',
  );
  if (!await cacheDirectory.exists()) {
    await cacheDirectory.create(recursive: true);
  }
  return cacheDirectory;
}

String _sanitizeWord(String word) {
  return word.replaceAll(RegExp(r'[^\w\s-]'), '').replaceAll(' ', '_');
}

File _buildFilePath(Directory cacheDirectory, String word) {
  return File('${cacheDirectory.path}/$word.mp3');
}

Uri _buildWordUrl(String word, String audioCode) {
  return Uri.parse(
    'https://upload.wikimedia.org/wikipedia/commons/transcoded/${audioCode[0]}/$audioCode/Nl-$word.ogg/Nl-$word.ogg.mp3',
  );
}

Future<void> playCachedOrUrl(String word, String audioCode) async {
  final sanitizedWord = _sanitizeWord(word);
  final cacheDirectory = await _getOrCreateCacheDirectory(audioCode);
  final file = _buildFilePath(cacheDirectory, sanitizedWord);

  if (!await file.exists()) {
    final response = await http.get(_buildWordUrl(sanitizedWord, audioCode));
    if (response.statusCode != 200) {
      throw Exception('Failed to download audio for word: $word');
    }
    await file.writeAsBytes(response.bodyBytes);
  }

  final player = AudioPlayer();
  player.onPlayerComplete.listen((_) => player.dispose());
  await player.play(DeviceFileSource(file.path));
}
