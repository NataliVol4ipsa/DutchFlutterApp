import 'package:dutch_app/pages/settings/setting_tiles/setting_tile_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

/// A settings tile that behaves like a button: tapping it runs [onTap].
class SettingActionTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final String? subtitle;
  final IconData actionIcon;
  final Color? actionColor;
  final GestureTapCallback onTap;

  const SettingActionTile({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
    this.subtitle,
    this.actionIcon = Icons.chevron_right,
    this.actionColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderStyles.bigBorderRadius,
        ),
        onTap: onTap,
        child: SettingTile(
          icon: icon,
          name: name,
          subtitle: subtitle,
          actionWidget: Center(
            child: Icon(
              actionIcon,
              color: actionColor ?? Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }
}
