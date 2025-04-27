class TranslationSearchResultSentenceExample {
  final String dutchSentence;
  final String englishSentence;
  late int relevanceScore;
  TranslationSearchResultSentenceExample(
      this.dutchSentence, this.englishSentence, bool isRelevant) {
    relevanceScore = isRelevant ? 1 : 0;
  }
}
