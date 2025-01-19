import 'package:dutch_app/core/models/word.dart';

class PracticeSessionStatefulService {
  late List<Word> words;
  PracticeSessionStatefulService() {
    words = [];
  }

  void initializeWords(List<Word> words) {
    this.words = words;
  }

  void cleanup() {
    words = [];
  }
}
