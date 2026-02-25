import 'package:dutch_app/pages/settings/settings_tile_config.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:dutch_app/styles/icon_styles.dart';
import 'package:dutch_app/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SettingTile extends StatelessWidget {
  final String name;
  final Widget actionWidget;
  final IconData? icon;
  final String? subtitle;

  const SettingTile({
    super.key,
    required this.name,
    required this.actionWidget,
    this.icon,
    this.subtitle,
  });

  Widget _buildIconSection(context) {
    if (icon == null) return Container();
    return Expanded(
      flex: SettingsTileConfig.settingIconFlex,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Icon(icon, color: IconStyles.defaultColor(context)),
      ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  name,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.settingsTitleStyle,
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
              ],
            ),
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
