// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class GenericDropdownMenu<T> extends StatefulWidget {
  final List<T> dropdownValues;
  final ValueChanged<T?> onValueChanged;
  final String Function(T value) displayString;
  final T? initialValue;

  const GenericDropdownMenu({
    super.key,
    required this.onValueChanged,
    required this.dropdownValues,
    required this.displayString,
    this.initialValue,
  });

  @override
  State<GenericDropdownMenu<T>> createState() => _GenericDropdownMenuState<T>();
}

class _GenericDropdownMenuState<T> extends State<GenericDropdownMenu<T>> {
  late T selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.dropdownValues.first;
  }

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<T>(
      initialSelection: widget.initialValue ?? widget.dropdownValues.first,
      onSelected: (T? value) {
        setState(() {
          selectedValue = value as T;
          widget.onValueChanged(selectedValue);
        });
      },
      dropdownMenuEntries:
          widget.dropdownValues.map<DropdownMenuEntry<T>>((T value) {
        return DropdownMenuEntry<T>(
          value: value,
          label: value.toString(),
        );
      }).toList(),
    );
  }
}
