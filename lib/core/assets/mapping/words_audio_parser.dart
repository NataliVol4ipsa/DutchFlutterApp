import 'package:dutch_app/core/assets/models/word_audio_asset.dart';

class WordsAudioParser {
  static List<WordAudioAsset> parse(String rawInput) {
    final seen = <String>{};
    final result = <WordAudioAsset>[];

    rawInput.split(RegExp(r'\r?\n')).forEach((line) {
      if (!line.contains(';')) return;
      final parts = line.split(';');
      final word = parts[1];
      if (seen.add(word)) {
        result.add(WordAudioAsset(code: parts[0], word: word));
      }
    });

    return result;
  }
}
