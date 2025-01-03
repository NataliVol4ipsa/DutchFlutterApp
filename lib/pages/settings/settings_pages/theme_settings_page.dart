import 'package:first_project/pages/settings/setting_tiles/setting_switch_tile_widget.dart';
import 'package:first_project/pages/settings/settings_section_widget.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class ThemeSettingsPage extends StatefulWidget {
  static const name = "Theme";
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  late bool showUseDarkTheme;

  @override
  void initState() {
    super.initState();
    showUseDarkTheme = false; //todo load from preserved settings
  }

  Widget _buildSettings(BuildContext context) {
    final List<Widget> sections = [
      _buildThemeSettings(context),
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

  void _onUseSystemThemeChanged(bool useSystemTheme) {
    setState(() {
      showUseDarkTheme = !useSystemTheme;
    });
  }

  Widget _buildThemeSettings(BuildContext context) {
    return SettingsSection(children: [
      SettingsSwitchTile(
        name: "Use system theme",
        onChanged: _onUseSystemThemeChanged,
      ),
      if (showUseDarkTheme) const SettingsSwitchTile(name: "Use dark theme"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "${ThemeSettingsPage.name} Settings",
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
