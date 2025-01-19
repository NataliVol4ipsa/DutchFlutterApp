import 'package:dutch_app/pages/word_editor/inputs/form_input_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

class FormTextInput extends StatefulWidget {
  final TextEditingController textInputController;
  final String? inputLabel;
  final bool isRequired;
  final String? hintText;
  final bool Function(String?)? valueValidator;
  final String? invalidInputErrorMessage;
  final Widget? suffixIcon;
  const FormTextInput(
      {super.key,
      required this.textInputController,
      this.hintText,
      this.inputLabel,
      this.isRequired = false,
      this.valueValidator,
      this.invalidInputErrorMessage,
      this.suffixIcon});

  @override
  State<FormTextInput> createState() => _FormTextInputState();
}

class _FormTextInputState extends State<FormTextInput> {
  @override
  Widget build(BuildContext context) {
    return FormInput(
      inputLabel: widget.inputLabel,
      isRequired: widget.isRequired,
      child: TextFormField(
        controller: widget.textInputController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderStyles.defaultBorderRadius),
          hintText: widget.hintText,
          suffixIcon: widget.suffixIcon,
          contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        ),
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (value) {
          if (widget.valueValidator != null && !widget.valueValidator!(value)) {
            return widget.invalidInputErrorMessage;
          }
          return null;
        },
      ),
    );
  }
}
