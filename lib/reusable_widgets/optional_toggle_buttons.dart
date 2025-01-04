// ignore_for_file: prefer_const_constructors
import 'package:dutch_app/reusable_widgets/models/toggle_button_item.dart';
import 'package:flutter/material.dart';

class OptionalToggleButtons<T> extends StatefulWidget {
  final List<ToggleButtonItem<T>> items;
  final T? selectedValue;
  final ValueChanged<T?> onChanged;

  const OptionalToggleButtons({
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    super.key,
  });

  @override
  State<OptionalToggleButtons> createState() =>
      _OptionalToggleButtonsState<T>();
}

class _OptionalToggleButtonsState<T> extends State<OptionalToggleButtons<T>> {
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    isSelected = widget.items.map((item) {
      return item.value == widget.selectedValue;
    }).toList();
  }

  @override
  void didUpdateWidget(OptionalToggleButtons<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedValue != widget.selectedValue) {
      setState(() {
        isSelected = widget.items.map((item) {
          return item.value == widget.selectedValue;
        }).toList();
      });
    }
  }

  void onPressedHandler(int index) {
    setState(() {
      if (isSelected[index]) {
        isSelected[index] = false;
        widget.onChanged(null);
      } else {
        for (int i = 0; i < isSelected.length; i++) {
          isSelected[i] = i == index;
        }
        widget.onChanged(widget.items[index].value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double buttonWidth =
            (constraints.maxWidth - (widget.items.length + 2)) /
                widget.items.length;

        return ToggleButtons(
          isSelected: isSelected,
          onPressed: onPressedHandler,
          borderRadius: BorderRadius.circular(18),
          children: widget.items.map((item) {
            return SizedBox(
              width: buttonWidth,
              child: Center(child: Text(item.label)),
            );
          }).toList(),
        );
      },
    );
  }
}
