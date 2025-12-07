import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SettingsSliderTile extends StatefulWidget {
  final String name;
  final double minimumValue;
  final double maximumValue;
  final double initialValue;
  final double step;
  final ValueChanged<double>? onChanged;

  const SettingsSliderTile({
    super.key,
    required this.name,
    required this.minimumValue,
    required this.maximumValue,
    required this.initialValue,
    this.step = 1,
    this.onChanged,
  });

  @override
  State<SettingsSliderTile> createState() => _SettingsSliderTileState();
}

class _SettingsSliderTileState extends State<SettingsSliderTile> {
  late double currentValue;
  late TextEditingController _textController;

  @override
  void initState() {
    super.initState();

    currentValue = widget.initialValue.clamp(
      widget.minimumValue,
      widget.maximumValue,
    );

    _textController = TextEditingController(
      text: currentValue.toInt().toString(),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _setCurrentValue(double newValue, {bool notify = true}) {
    // Snap to step and clamp
    final snapped = (newValue / widget.step).round() * widget.step;
    final clamped = snapped.clamp(widget.minimumValue, widget.maximumValue);

    if (clamped == currentValue) return;

    setState(() {
      currentValue = clamped;
      _textController.text = currentValue.toInt().toString();
    });

    if (notify) {
      widget.onChanged?.call(currentValue);
    }
  }

  void _onSliderChanged(double newValue) {
    _setCurrentValue(newValue);
  }

  void _onTextSubmitted(String value) {
    final parsed = int.tryParse(value);
    if (parsed == null) {
      // Restore previous value if invalid
      _textController.text = currentValue.toInt().toString();
      return;
    }

    _setCurrentValue(parsed.toDouble());
  }

  Widget _buildSlider(BuildContext context) {
    return Slider(
      value: currentValue,
      min: widget.minimumValue,
      max: widget.maximumValue,
      divisions: ((widget.maximumValue - widget.minimumValue) / widget.step)
          .round(),
      onChanged: _onSliderChanged,
      activeColor: Theme.of(context).colorScheme.secondary,
      inactiveColor: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
      thumbColor: Theme.of(context).colorScheme.secondary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  left: ContainerStyles.containerPadding.left + 5,
                  top: ContainerStyles.containerPadding.top,
                  right: ContainerStyles.containerPadding.right,
                  bottom: ContainerStyles.containerPadding.bottom / 2,
                ),
                child: Text(
                  widget.name,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.settingsTitleStyle,
                ),
              ),
              SizedBox(
                height: 25,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: ContainerStyles.containerPadding.bottom,
                  ),
                  child: _buildSlider(context),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 80,
          child: Padding(
            padding: ContainerStyles.containerPadding,
            child: TextField(
              controller: _textController,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              maxLength: widget.maximumValue.toInt().toString().length,
              decoration: const InputDecoration(
                isDense: true,
                counterText: '',
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 2,
                ),
                border: OutlineInputBorder(),
              ),
              onSubmitted: _onTextSubmitted,
            ),
          ),
        ),
      ],
    );
  }
}
