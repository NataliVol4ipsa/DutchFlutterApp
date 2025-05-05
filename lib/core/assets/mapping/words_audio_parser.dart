import 'package:dutch_app/core/assets/models/dutch_word_asset.dart';

class WordsAudioParser {
  static List<DutchWordAsset> parse(String rawInput) {
    final seen = <String>{};
    final result = <DutchWordAsset>[];

    rawInput.split(RegExp(r'\r?\n')).forEach((line) {
      if (!line.contains(';')) return;
      final parts = line.split(';');
      final word = parts[1].toLowerCase();
      if (seen.add(word)) {
        result
            .add(DutchWordAsset(audioCode: parts[0].toLowerCase(), word: word));
      }
    });

    return result;
  }
}
