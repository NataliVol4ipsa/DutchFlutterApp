import 'package:dutch_app/domain/models/verb_details/word_verb_imperative_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_past_tense_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_participle_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_tense_details.dart';

class WordVerbDetails {
  final String? infinitive; //infinitief
  final String? completedParticiple; //voltooid deelwoord
  final String? auxiliaryVerb; //aanvoegende wijs
  final WordVerbImperativeDetails imperative; //gebiedende wijs
  final WordVerbPresentParticipleDetails
      presentParticiple; //tegenwoordig deelwoord
  final WordVerbPresentTenseDetails presentTense; //tegenwoordige tijd
  final WordVerbPastTenseDetails pastTense; //tegenwoordige tijd

  WordVerbDetails(
      {required this.infinitive,
      required this.completedParticiple,
      required this.auxiliaryVerb,
      required this.imperative,
      required this.presentParticiple,
      required this.presentTense,
      required this.pastTense});
}
