import 'package:dutch_app/domain/models/word_noun_details.dart';
import 'package:dutch_app/domain/types/de_het_type.dart';
import 'package:flutter/material.dart';

class NounControllers {
  final TextEditingController diminutive = TextEditingController();
  final ValueNotifier<DeHetType> deHetType =
      ValueNotifier<DeHetType>(DeHetType.none);
  final TextEditingController dutchPluralForm = TextEditingController();

  void initializeFromDetails(WordNounDetails? details) {
    if (details == null) return;

    dutchPluralForm.text = details.pluralForm ?? "";
    deHetType.value = details.deHetType;
    diminutive.text = details.diminutive ?? "";
  }
}
