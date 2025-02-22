import 'package:dutch_app/reusable_widgets/models/toggle_button_item.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
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

        return Container(
          decoration: BoxDecoration(
            color: ContainerStyles.sectionColor(context),
            borderRadius: BorderStyles.defaultBorderRadius,
          ),
          child: ToggleButtons(
            fillColor: ButtonStyles.secondaryButtonColor(context),
            splashColor:
                ButtonStyles.secondaryButtonColor(context).withAlpha(100),
            isSelected: isSelected,
            onPressed: onPressedHandler,
            borderRadius: BorderStyles.defaultBorderRadius,
            borderColor: BorderStyles.enabledBorderColor,
            children: widget.items.map((item) {
              return SizedBox(
                  width: buttonWidth,
                  child: Center(
                    child: Text(item.label,
                        style: TextStyle(
                            color: ContainerStyles.sectionTextColor(context))),
                  ));
            }).toList(),
          ),
        );
      },
    );
  }
}
