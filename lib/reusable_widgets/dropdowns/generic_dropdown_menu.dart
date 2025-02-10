import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class GenericDropdownMenu<T> extends StatefulWidget {
  final List<T> dropdownValues;
  final ValueChanged<T?> onValueChanged;
  final String Function(T value) displayStringFunc;
  final T? initialValue;
  final Widget? prefixIcon;
  final Color? dropdownArrowColor;
  final Color? Function(T)? dropdownOptionColorGenerator;

  const GenericDropdownMenu({
    super.key,
    required this.onValueChanged,
    required this.dropdownValues,
    required this.displayStringFunc,
    this.initialValue,
    this.prefixIcon,
    this.dropdownArrowColor,
    this.dropdownOptionColorGenerator,
  });

  @override
  State<GenericDropdownMenu<T>> createState() => _GenericDropdownMenuState<T>();
}

class _GenericDropdownMenuState<T> extends State<GenericDropdownMenu<T>> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity, // Make sure the dropdown takes full width
      child: Container(
        decoration:
            BoxDecoration(borderRadius: BorderStyles.defaultBorderRadius),
        child: Theme(
          data: Theme.of(context)
              .copyWith(canvasColor: ContainerStyles.section2Color(context)),
          child: DropdownButtonFormField<T?>(
            isExpanded: true,
            value: widget.initialValue,
            iconEnabledColor: widget.dropdownArrowColor,
            onChanged: (T? value) {
              if (value != null) {
                widget.onValueChanged(value);
                setState(() {});
              }
            },
            items: widget.dropdownValues.map<DropdownMenuItem<T>>((T value) {
              return DropdownMenuItem<T>(
                  value: value,
                  child: Text(
                    widget.displayStringFunc(value),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: widget.dropdownOptionColorGenerator == null
                            ? null
                            : widget.dropdownOptionColorGenerator!(value)),
                  ));
            }).toList(),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderStyles.defaultBorderRadius),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              prefixIcon: widget.prefixIcon,
            ),
          ),
        ),
      ),
    );
  }
}
