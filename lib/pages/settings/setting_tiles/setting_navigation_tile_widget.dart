import 'package:first_project/pages/settings/setting_tiles/setting_tile_widget.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SettingNavigationTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final GestureTapCallback onTap;
  const SettingNavigationTile({
    super.key,
    required this.icon,
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(ContainerStyles.roundedEdgeRadius),
        ),
        onTap: onTap,
        child: SettingTile(
          icon: icon,
          name: name,
          actionWidget: const Center(child: Text(">")),
        ),
      ),
    );
  }
}
