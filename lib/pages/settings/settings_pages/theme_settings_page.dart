import 'package:first_project/pages/settings/settings_section_widget.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ThemeSettingsPage extends StatelessWidget {
  static const name = "Theme";
  const ThemeSettingsPage({super.key});
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

  Widget _buildThemeSettings(BuildContext context) {
    return SettingsSection(children: [
      Align(alignment: Alignment.centerLeft, child: Text("Use system theme")),
      Align(alignment: Alignment.centerLeft, child: Text("Use dark theme")),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "$name Settings",
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
