import 'package:dutch_app/pages/settings/setting_tiles/setting_tile_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:flutter/material.dart';

class SettingNavigationTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final GestureTapCallback onTap;
  final bool isLocked;

  const SettingNavigationTile({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
    this.isLocked = false,
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
          subtitle: isLocked ? "Not editable during session" : null,
          actionWidget: isLocked
              ? Center(
                  child: Icon(
                    Icons.lock_outline,
                    size: 18,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                )
              : const Center(child: Text(">")),
        ),
      ),
    );
  }
}
