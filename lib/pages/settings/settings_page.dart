import 'package:first_project/pages/settings/setting_tiles/setting_navigation_tile_widget.dart';
import 'package:first_project/pages/settings/settings_pages/theme_settings_page.dart';
import 'package:first_project/pages/settings/settings_section_widget.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildSettings(BuildContext context) {
    final List<Widget> sections = [
      _buildUiSettingsSection(context),
    ];

    return Container(
        color: ContainerStyles.defaultColor(context),
        child: ListView.builder(
          itemCount: sections.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: ContainerStyles.betweenCardsPadding,
              child: sections[index],
            );
          },
        ));
  }

  Widget _buildUiSettingsSection(BuildContext context) {
    return SettingsSection(useShortDivider: true, children: [
      SettingNavigationTile(
          icon: Icons.brightness_4,
          name: ThemeSettingsPage.name,
          onTap: () {
            _goToPage(context, const ThemeSettingsPage());
          }),
      SettingNavigationTile(
          icon: Icons.brightness_4,
          name: ThemeSettingsPage.name,
          onTap: () {
            _goToPage(context, const ThemeSettingsPage());
          }),
    ]);
  }

  _goToPage(BuildContext context, Widget pageToOpenOnTap) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => pageToOpenOnTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
          padding: ContainerStyles.containerPadding,
          child: _buildSettings(context)),
    );
  }
}
