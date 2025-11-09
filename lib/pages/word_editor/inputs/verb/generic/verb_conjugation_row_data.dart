import 'package:flutter/material.dart';

class VerbConjugationRowData {
  final String pronoun;
  final TextEditingController controller;
  final String suffix;
  final String? inputHint;

  VerbConjugationRowData({
    required this.pronoun,
    required this.controller,
    required this.suffix,
    this.inputHint,
  });
}
