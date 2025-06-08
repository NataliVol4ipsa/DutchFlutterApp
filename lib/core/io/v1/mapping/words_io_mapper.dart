import 'package:dutch_app/core/io/v1/models/export_word_collection_v1.dart';
import 'package:dutch_app/core/io/v1/models/export_word_v1.dart';
import 'package:dutch_app/domain/models/new_word_collection.dart';
import 'package:dutch_app/domain/models/new_word.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_imperative_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_past_tense_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_participle_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_tense_details.dart';
import 'package:dutch_app/domain/models/word_collection.dart';
import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/part_of_speech.dart';
import 'package:dutch_app/core/io/v1/models/export_package_v1.dart';

class WordsIoMapper {
  static ExportPackageV1 toExportPackageV1(List<WordCollection> collections) {
    return ExportPackageV1(collections
        .map((collection) => ExportWordCollectionV1.fromCollection(collection))
        .toList());
  }

  static List<NewWordCollection> toNewCollectionList(ExportPackageV1 package) {
    return package.collections
        .map((collection) => toNewCollection(collection))
        .toList();
  }

  static NewWordCollection toNewCollection(ExportWordCollectionV1 collection) {
    return NewWordCollection(collection.name,
        words: collection.words.map((wordDto) => toNewWord(wordDto)).toList());
  }

  static NewWord toNewWord(ExportWordV1 source) {
    if (source.dutchWord == null) {
      throw Exception("Cannot create word without dutchWord");
    }
    if (source.englishWords == null) {
      throw Exception("Cannot create word without englishWords");
    }

    var wordType = source.partOfSpeech ?? PartOfSpeech.unspecified;

    var nounDetails = source.nounDetails != null
        ? WordNounDetails(
            deHetType: source.nounDetails!.deHetType,
            pluralForm: source.nounDetails!.pluralForm,
            diminutive: source.nounDetails!.diminutive,
          )
        : null;

    var verbDetails = source.verbDetails != null
        ? WordVerbDetails(
            infinitive: source.verbDetails!.infinitive,
            completedParticiple: source.verbDetails!.completedParticiple,
            auxiliaryVerb: source.verbDetails!.auxiliaryVerb,
            imperative: WordVerbImperativeDetails(
              informal: source.verbDetails!.imperative.informal,
              formal: source.verbDetails!.imperative.formal,
            ),
            presentParticiple: WordVerbPresentParticipleDetails(
              inflected: source.verbDetails!.presentParticiple.inflected,
              uninflected: source.verbDetails!.presentParticiple.uninflected,
            ),
            presentTense: WordVerbPresentTenseDetails(
              ik: source.verbDetails!.presentTense.ik,
              jijVraag: source.verbDetails!.presentTense.jijVraag,
              jij: source.verbDetails!.presentTense.jij,
              u: source.verbDetails!.presentTense.u,
              hijZijHet: source.verbDetails!.presentTense.hijZijHet,
              wij: source.verbDetails!.presentTense.wij,
              jullie: source.verbDetails!.presentTense.jullie,
              zij: source.verbDetails!.presentTense.zij,
            ),
            pastTense: WordVerbPastTenseDetails(
              ik: source.verbDetails!.pastTense.ik,
              jij: source.verbDetails!.pastTense.jij,
              hijZijHet: source.verbDetails!.pastTense.hijZijHet,
              wij: source.verbDetails!.pastTense.wij,
              jullie: source.verbDetails!.pastTense.jullie,
              zij: source.verbDetails!.pastTense.zij,
            ),
          )
        : null;

    return NewWord(
      source.dutchWord!,
      source.englishWords!,
      wordType,
      contextExample: source.contextExample,
      contextExampleTranslation: source.contextExampleTranslation,
      userNote: source.userNote,
      nounDetails: nounDetails,
      verbDetails: verbDetails,
    );
  }
}
