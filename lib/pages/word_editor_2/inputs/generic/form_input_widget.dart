import 'package:dutch_app/reusable_widgets/input_label.dart';
import 'package:flutter/material.dart';

class FormInput extends StatelessWidget {
  const FormInput(
      {super.key,
      required this.child,
      this.inputLabel,
      this.isRequired = false});

  final String? inputLabel;
  final bool isRequired;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (inputLabel != null)
          InputLabel(
            inputLabel!,
            isRequired: isRequired,
          ),
        child,
      ],
    );
  }
}
