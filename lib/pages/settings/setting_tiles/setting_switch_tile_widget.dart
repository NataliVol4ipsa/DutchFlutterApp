import 'package:dutch_app/pages/settings/setting_tiles/setting_tile_widget.dart';
import 'package:flutter/material.dart';

class SettingsSwitchTile extends StatefulWidget {
  final String name;
  final bool isInitiallyEnabled;
  final ValueChanged<bool>? onChanged;
  final bool isLocked;

  const SettingsSwitchTile({
    super.key,
    required this.name,
    this.isInitiallyEnabled = false,
    this.onChanged,
    this.isLocked = false,
  });

  @override
  State<SettingsSwitchTile> createState() => _SettingsSwitchTileState();
}

class _SettingsSwitchTileState extends State<SettingsSwitchTile> {
  late bool isEnabled;

  @override
  void initState() {
    super.initState();
    isEnabled = widget.isInitiallyEnabled;
  }

  Widget _buildAction(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 50,
        height: 20,
        child: Switch(
          value: isEnabled,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          onChanged: widget.isLocked ? null : onValueChanged,
        ),
      ),
    );
  }

  void onValueChanged(bool value) {
    setState(() {
      isEnabled = value;
    });
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingTile(name: widget.name, actionWidget: _buildAction(context));
  }
}
