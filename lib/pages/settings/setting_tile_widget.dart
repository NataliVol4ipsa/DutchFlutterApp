import 'package:first_project/pages/settings/settings_tile_config.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/icon_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final IconData icon;
  final String name;
  final GestureTapCallback onTap;
  const SettingTile({
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
          borderRadius: BorderRadius.circular(ContainerStyles
              .roundedEdgeRadius), // Same border radius as Container
        ),
        onTap: onTap,
        child: Container(
          padding: ContainerStyles.containerPadding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: SettingsTileConfig.settingIconFlex,
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Icon(icon, color: IconStyles.defaultColor(context))),
              ),
              Expanded(
                flex: SettingsTileConfig.settingNameFlex,
                child: Text(name,
                    maxLines: 2,
                    softWrap: true,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.settingsTitleStyle),
              ),
              const Expanded(
                flex: SettingsTileConfig.settingOpenFlex,
                child: Center(child: Text(">")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
