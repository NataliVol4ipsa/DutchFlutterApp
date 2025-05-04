import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:dutch_app/domain/types/word_type.dart';

class GetWordGrammarOnlineResponse {
  final String word;
  late WordType? partOfSpeech;
  late String? note;
  late final GetWordGrammarNounDetailsDto nounDetails;
  late final GetWordGrammarVerbDetailsDto verbDetails;
  GetWordGrammarOnlineResponse(this.word) {
    nounDetails = GetWordGrammarNounDetailsDto();
    verbDetails = GetWordGrammarVerbDetailsDto();
  }
}

class GetWordGrammarNounDetailsDto {
  late DeHetType? gender;
  late String? pluralForm;
  late String? diminutive;
  GetWordGrammarNounDetailsDto();
}

class GetWordGrammarVerbDetailsDto {
  late String? infinitive; //infinitief
  late String? completedParticiple; //voltooid deelwoord
  late String? auxiliaryVerb; //aanvoegende wijs
  late GetWordGrammarVerbImperativeDto imperative; //gebiedende wijs
  late GetWordGrammarVerbPresentParticipleDto
      presentParticiple; //tegenwoordig deelwoord
  late GetWordGrammarVerbPresentTenseDto presentTense; //tegenwoordige tijd
  late GetWordGrammarVerbPastTenseDto pastTense; //tegenwoordige tijd
  GetWordGrammarVerbDetailsDto() {
    imperative = GetWordGrammarVerbImperativeDto();
    presentParticiple = GetWordGrammarVerbPresentParticipleDto();
    presentTense = GetWordGrammarVerbPresentTenseDto();
    pastTense = GetWordGrammarVerbPastTenseDto();
  }
}

class GetWordGrammarVerbPresentTenseDto {
  late String? ik;
  late String? jijVraag;
  late String? jij;
  late String? u;
  late String? hijZijHet;
  late String? wij;
  late String? jullie;
  late String? zij;
}

class GetWordGrammarVerbPastTenseDto {
  late String? ik;
  late String? jij;
  late String? hijZijHet;
  late String? wij;
  late String? jullie;
  late String? zij;
}

class GetWordGrammarVerbImperativeDto {
  late String? informal;
  late String? formal;
}

class GetWordGrammarVerbPresentParticipleDto {
  late String? uninflected;
  late String? inflected;
}
