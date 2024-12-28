import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  Widget _buildThemeSettings(BuildContext context) {
    return Container();
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
      body: _buildSettings(context),
    );
  }
}
