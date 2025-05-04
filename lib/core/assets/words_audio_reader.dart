import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';

class WordsAudioReader {
  Future<List<List<String>>> readCsvFile() async {
    // Load the raw CSV string from the asset
    final rawCsv = await rootBundle.loadString('assets/data/words_audio.csv');

    // Parse with semicolon delimiter
    final parsedCsv = CsvToListConverter(fieldDelimiter: ';')
        .convert(rawCsv)
        .map((row) => row.map((e) => e.toString()).toList())
        .toList();

    return parsedCsv;
  }
}
