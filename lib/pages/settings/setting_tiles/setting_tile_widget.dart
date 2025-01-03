import 'package:first_project/pages/settings/settings_tile_config.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/icon_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String name;
  final Widget actionWidget;
  final IconData? icon;

  const SettingTile({
    super.key,
    required this.name,
    required this.actionWidget,
    this.icon,
  });

  Widget _buildIconSection(context) {
    if (icon == null) return Container();
    return Expanded(
      flex: SettingsTileConfig.settingIconFlex,
      child: Align(
          alignment: Alignment.centerLeft,
          child: Icon(icon, color: IconStyles.defaultColor(context))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: ContainerStyles.containerPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildIconSection(context),
          Expanded(
            flex: SettingsTileConfig.settingNameFlex,
            child: Text(name,
                maxLines: 2,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.settingsTitleStyle),
          ),
          Expanded(
            flex: SettingsTileConfig.settingActionFlex,
            child: actionWidget,
          ),
        ],
      ),
    );
  }
}
