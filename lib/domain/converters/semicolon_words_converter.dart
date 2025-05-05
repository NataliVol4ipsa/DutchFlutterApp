class SemicolonWordsConverter {
  static const String delimiter = ";";
  static List<String> fromString(String input) {
    return input
        .split(delimiter)
        .map((w) => _cleanWord(w.trim().toLowerCase()))
        .where((w) => w != "")
        .toSet()
        .toList();
  }

  static String _cleanWord(String word) {
    final isInfinitive = word.startsWith('to ');
    final cleanedWord = isInfinitive ? word.substring(3).trim() : word;
    return cleanedWord;
  }

  static String toSingleString(List<String> input) {
    return input.join(delimiter);
  }
}
