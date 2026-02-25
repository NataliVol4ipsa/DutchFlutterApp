import 'package:dutch_app/pages/settings/settings_tile_config.dart';
import 'package:dutch_app/reusable_widgets/section_container_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

// Accepts list of setting tiles, puts dividers between them and wraps into nice section container
class SettingsSection extends StatelessWidget {
  final List<Widget> children;
  final bool useShortDivider;
  final String? lockedHint;
  const SettingsSection({
    super.key,
    required this.children,
    this.useShortDivider = false,
    this.lockedHint,
  });

  List<Widget> _buildSectionChildrenWithDividers(
    BuildContext context,
    List<Widget> widgets,
  ) {
    if (widgets.isEmpty) return [];

    List<Widget> result = [];
    for (int i = 0; i < widgets.length; i++) {
      result.add(widgets[i]);
      if (i < widgets.length - 1) {
        result.add(_dividerRow(context));
      }
    }
    return result;
  }

  Widget _dividerRow(BuildContext context) {
    return Padding(
      padding: _buildPadding(),
      child: Row(
        children: [
          Expanded(
            flex: SettingsTileConfig.settingIconFlex,
            child: _buildLeftDivider(context),
          ),
          Expanded(
            flex: SettingsTileConfig.settingNameFlex,
            child: _divider(context),
          ),
          Expanded(
            flex: SettingsTileConfig.settingActionFlex,
            child: _divider(context),
          ),
        ],
      ),
    );
  }

  //todo improve padding - its not very universal
  EdgeInsets _buildPadding() {
    if (useShortDivider) {
      return const EdgeInsets.only(right: 16);
    }
    return const EdgeInsets.symmetric(horizontal: 16);
  }

  Widget _buildLeftDivider(BuildContext context) {
    if (useShortDivider) {
      return Container();
    }
    return _divider(context);
  }

  static Widget _divider(BuildContext context) {
    return const Divider(
      thickness: 1,
      height: 1, // Remove extra vertical padding
    );
  }

  @override
  Widget build(BuildContext context) {
    return SectionContainer(
      color: ContainerStyles.sectionColor(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ..._buildSectionChildrenWithDividers(context, children),
          if (lockedHint != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 13,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    lockedHint!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
