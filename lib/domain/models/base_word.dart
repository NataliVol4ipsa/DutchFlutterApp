import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/models/word_verb_details.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';

class BaseWord {
  final String dutchWord;
  final List<String> englishWords;
  final PartOfSpeech partOfSpeech;
  final WordCollection? collection;
  final String? contextExample;
  final String? contextExampleTranslation;
  final String? userNote;
  final String? audioCode;
  final WordNounDetails? nounDetails;
  final WordVerbDetails? verbDetails;

  BaseWord(this.dutchWord, this.englishWords, this.partOfSpeech,
      {this.collection,
      this.contextExample,
      this.contextExampleTranslation,
      this.userNote,
      this.audioCode,
      required this.nounDetails,
      required this.verbDetails});
}
