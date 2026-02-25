import 'package:dutch_app/domain/models/word.dart';

class PracticeSessionStatefulService {
  late List<Word> words;

  bool get isSessionActive => words.isNotEmpty;

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
