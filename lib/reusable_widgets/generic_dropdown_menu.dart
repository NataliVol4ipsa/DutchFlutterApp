// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class GenericDropdownMenu<T extends Enum> extends StatefulWidget {
  final List<T> dropdownValues;
  final ValueChanged<T?> onValueChanged;
  final String Function(T value) displayStringFunc;
  final T? initialValue;

  const GenericDropdownMenu({
    super.key,
    required this.onValueChanged,
    required this.dropdownValues,
    required this.displayStringFunc,
    this.initialValue,
  });

  @override
  State<GenericDropdownMenu<T>> createState() => _GenericDropdownMenuState<T>();
}

class _GenericDropdownMenuState<T extends Enum>
    extends State<GenericDropdownMenu<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue ?? widget.dropdownValues.first;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make sure the dropdown takes full width
      child: DropdownButtonFormField<T?>(
        value: selectedValue,
        onChanged: (T? value) {
          setState(() {
            selectedValue = value as T;
            widget.onValueChanged(selectedValue);
          });
        },
        items: widget.dropdownValues.map<DropdownMenuItem<T>>((T value) {
          return DropdownMenuItem<T>(
            value: value,
            child: Text(widget.displayStringFunc(value)),
          );
        }).toList(),
        decoration: InputDecoration(
          border: OutlineInputBorder(), // Matching the TextField style
        ),
      ),
    );
  }
}
