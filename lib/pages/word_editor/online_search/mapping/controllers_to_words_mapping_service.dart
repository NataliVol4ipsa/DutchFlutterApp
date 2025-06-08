import 'package:dutch_app/domain/converters/semicolon_words_converter.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_imperative_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_past_tense_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_participle_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_tense_details.dart';
import 'package:dutch_app/pages/word_editor/controllers/main_controllers.dart';
import 'package:dutch_app/pages/word_editor/controllers/noun_controllers.dart';
import 'package:dutch_app/pages/word_editor/controllers/verb_controllers.dart';

class ControllersToWordsMappingService {
  static NewWord toNewWord({
    required MainControllers main,
    required NounControllers noun,
    required VerbControllers verb,
  }) {
    return NewWord(
      main.dutchWordController.text.trim(),
      SemicolonWordsConverter.fromString(
          main.englishWordController.text.trim()),
      main.wordTypeController.value,
      collection: main.wordCollectionController.value,
      contextExample: main.contextExampleController.text.trim(),
      contextExampleTranslation:
          main.contextExampleTranslationController.text.trim(),
      userNote: main.userNoteController.text.trim(),
      nounDetails: _buildNounDetails(noun),
      verbDetails: _buildVerbDetails(verb),
    );
  }

  static Word toUpdatedWord({
    required int wordId,
    required MainControllers main,
    required NounControllers noun,
    required VerbControllers verb,
  }) {
    return Word(
      wordId,
      main.dutchWordController.text.trim(),
      SemicolonWordsConverter.fromString(
          main.englishWordController.text.trim()),
      main.wordTypeController.value,
      collection: main.wordCollectionController.value,
      contextExample: main.contextExampleController.text.trim(),
      contextExampleTranslation:
          main.contextExampleTranslationController.text.trim(),
      userNote: main.userNoteController.text.trim(),
      nounDetails: _buildNounDetails(noun),
      verbDetails: _buildVerbDetails(verb),
    );
  }

  static WordNounDetails _buildNounDetails(NounControllers noun) {
    return WordNounDetails(
      deHetType: noun.deHetType.value,
      pluralForm: noun.dutchPluralForm.text.trim(),
      diminutive: noun.diminutive.text.trim(),
    );
  }

  static WordVerbDetails _buildVerbDetails(VerbControllers verb) {
    return WordVerbDetails(
      infinitive: verb.infinitive.text.trim(),
      completedParticiple: verb.completedParticiple.text.trim(),
      auxiliaryVerb: verb.auxiliaryVerb.text.trim(),
      imperative: WordVerbImperativeDetails(
        informal: verb.imperative.informal.text.trim(),
        formal: verb.imperative.formal.text.trim(),
      ),
      presentParticiple: WordVerbPresentParticipleDetails(
        inflected: verb.presentParticiple.inflected.text.trim(),
        uninflected: verb.presentParticiple.uninflected.text.trim(),
      ),
      presentTense: WordVerbPresentTenseDetails(
        ik: verb.presentTense.ik.text.trim(),
        jijVraag: verb.presentTense.jijVraag.text.trim(),
        jij: verb.presentTense.jij.text.trim(),
        u: verb.presentTense.u.text.trim(),
        hijZijHet: verb.presentTense.hijZijHet.text.trim(),
        wij: verb.presentTense.wij.text.trim(),
        jullie: verb.presentTense.jullie.text.trim(),
        zij: verb.presentTense.zij.text.trim(),
      ),
      pastTense: WordVerbPastTenseDetails(
        ik: verb.pastTense.ik.text.trim(),
        jij: verb.pastTense.jij.text.trim(),
        hijZijHet: verb.pastTense.hijZijHet.text.trim(),
        wij: verb.pastTense.wij.text.trim(),
        jullie: verb.pastTense.jullie.text.trim(),
        zij: verb.pastTense.zij.text.trim(),
      ),
    );
  }
}
