import 'package:dutch_app/core/assets/mapping/words_audio_parser.dart';
import 'package:dutch_app/core/assets/models/dutch_word_asset.dart';
import 'package:flutter/services.dart' show rootBundle;

class WordsAudioReader {
  Future<List<DutchWordAsset>> readCsvFile() async {
    final rawCsv = await rootBundle.loadString('assets/data/words_audio.csv');

    return WordsAudioParser.parse(rawCsv);
  }
}
