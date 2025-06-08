import 'package:dutch_app/domain/models/verb_details/word_verb_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_imperative_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_past_tense_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_participle_details.dart';
import 'package:dutch_app/domain/models/verb_details/word_verb_present_tense_details.dart';
import 'package:dutch_app/pages/word_editor/online_search/models/translation_search_result.dart';
import 'package:flutter/material.dart';

class VerbControllers {
  final TextEditingController infinitive = TextEditingController();
  final TextEditingController completedParticiple = TextEditingController();
  final TextEditingController auxiliaryVerb = TextEditingController();

  final ImperativeControllers imperative = ImperativeControllers();
  final PresentParticipleControllers presentParticiple =
      PresentParticipleControllers();
  final PresentTenseControllers presentTense = PresentTenseControllers();
  final PastTenseControllers pastTense = PastTenseControllers();

  void initializeFromDetails(WordVerbDetails? details) {
    if (details == null) return;

    infinitive.text = details.infinitive ?? "";
    completedParticiple.text = details.completedParticiple ?? "";
    auxiliaryVerb.text = details.auxiliaryVerb ?? "";

    imperative.initializeFromDetails(details.imperative);
    presentParticiple.initializeFromDetails(details.presentParticiple);
    presentTense.initializeFromDetails(details.presentTense);
    pastTense.initializeFromDetails(details.pastTense);
  }

  void initializeFromTranslation(TranslationVerbDetails? details) {
    if (details == null) return;

    infinitive.text = details.infinitive ?? "";
    completedParticiple.text = details.completedParticiple ?? "";
    auxiliaryVerb.text = details.auxiliaryVerb ?? "";

    imperative.initializeFromTranslation(details.imperative);
    presentParticiple.initializeFromTranslation(details.presentParticiple);
    presentTense.initializeFromTranslation(details.presentTense);
    pastTense.initializeFromTranslation(details.pastTense);
  }
}

class ImperativeControllers {
  final TextEditingController informal = TextEditingController();
  final TextEditingController formal = TextEditingController();

  void initializeFromDetails(WordVerbImperativeDetails details) {
    informal.text = details.informal ?? "";
    formal.text = details.formal ?? "";
  }

  void initializeFromTranslation(TranslationVerbImperativeDetails? details) {
    informal.text = details?.informal ?? "";
    formal.text = details?.formal ?? "";
  }
}

class PresentParticipleControllers {
  final TextEditingController inflected = TextEditingController();
  final TextEditingController uninflected = TextEditingController();

  void initializeFromDetails(WordVerbPresentParticipleDetails details) {
    inflected.text = details.inflected ?? "";
    uninflected.text = details.uninflected ?? "";
  }

  void initializeFromTranslation(
      TranslationVerbPresentParticipleDetails? details) {
    inflected.text = details?.inflected ?? "";
    uninflected.text = details?.uninflected ?? "";
  }
}

class PresentTenseControllers {
  final TextEditingController ik = TextEditingController();
  final TextEditingController jijVraag = TextEditingController();
  final TextEditingController jij = TextEditingController();
  final TextEditingController u = TextEditingController();
  final TextEditingController hijZijHet = TextEditingController();
  final TextEditingController wij = TextEditingController();
  final TextEditingController jullie = TextEditingController();
  final TextEditingController zij = TextEditingController();

  void initializeFromDetails(WordVerbPresentTenseDetails details) {
    ik.text = details.ik ?? "";
    jijVraag.text = details.jijVraag ?? "";
    jij.text = details.jij ?? "";
    u.text = details.u ?? "";
    hijZijHet.text = details.hijZijHet ?? "";
    wij.text = details.wij ?? "";
    jullie.text = details.jullie ?? "";
    zij.text = details.zij ?? "";
  }

  void initializeFromTranslation(TranslationVerbPresentTenseDetails? details) {
    ik.text = details?.ik ?? "";
    jijVraag.text = details?.jijVraag ?? "";
    jij.text = details?.jij ?? "";
    u.text = details?.u ?? "";
    hijZijHet.text = details?.hijZijHet ?? "";
    wij.text = details?.wij ?? "";
    jullie.text = details?.jullie ?? "";
    zij.text = details?.zij ?? "";
  }
}

class PastTenseControllers {
  final TextEditingController ik = TextEditingController();
  final TextEditingController jij = TextEditingController();
  final TextEditingController hijZijHet = TextEditingController();
  final TextEditingController wij = TextEditingController();
  final TextEditingController jullie = TextEditingController();
  final TextEditingController zij = TextEditingController();

  void initializeFromDetails(WordVerbPastTenseDetails details) {
    ik.text = details.ik ?? "";
    jij.text = details.jij ?? "";
    hijZijHet.text = details.hijZijHet ?? "";
    wij.text = details.wij ?? "";
    jullie.text = details.jullie ?? "";
    zij.text = details.zij ?? "";
  }

  void initializeFromTranslation(TranslationVerbPastTenseDetails? details) {
    ik.text = details?.ik ?? "";
    jij.text = details?.jij ?? "";
    hijZijHet.text = details?.hijZijHet ?? "";
    wij.text = details?.wij ?? "";
    jullie.text = details?.jullie ?? "";
    zij.text = details?.zij ?? "";
  }
}
