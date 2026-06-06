import 'package:dutch_app/core/assets/models/dutch_word_asset.dart';

class WordsAudioParser {
  static List<DutchWordAsset> parse(String rawInput) {
    final seen = <String>{};
    final result = <DutchWordAsset>[];

    for (final line in rawInput.split(RegExp(r'\r?\n'))) {
      final word = line.trim().toLowerCase();
      if (word.isEmpty) continue;
      if (seen.add(word)) {
        result.add(DutchWordAsset(word: word));
      }
    }

    return result;
  }
}
