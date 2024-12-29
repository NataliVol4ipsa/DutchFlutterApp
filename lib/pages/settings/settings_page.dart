import 'package:first_project/reusable_widgets/section_container_widget.dart';
import 'package:first_project/styles/container_styles.dart';
import 'package:first_project/styles/icon_styles.dart';
import 'package:first_project/styles/text_styles.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  final int _settingIconFlex = 10;
  final int _settingNameFlex = 80;
  final int _settingOpenFlex = 10;

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
    return _buildSettingsSection(context, [
      _buildSettingTile(context, Icons.brightness_4, "Theme", () => {}),
      _buildSettingTile(
          context,
          Icons.brightness_4,
          "gdlfsjg sk gjsdk gs    gsdhgsdgsdjkglsdjklgsdkl  jsokgjdsko",
          () => {}),
    ]);
  }

  Widget _buildSettingsSection(BuildContext context, List<Widget> children) {
    return SectionContainer(
      color: ContainerStyles.sectionColor(context),
      child: Column(
        children: _buildSectionChildrenWithDividers(context, children),
      ),
    );
  }

  List<Widget> _buildSectionChildrenWithDividers(
      BuildContext context, List<Widget> widgets) {
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

  Widget _buildSettingTile(BuildContext context, IconData icon, String name,
      GestureTapCallback onTap) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        highlightColor:
            Colors.blue.withOpacity(0.2), // Optional: customize highlight color
        splashColor: Colors.blue.withOpacity(0.5), // Customize splash color
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: _settingIconFlex,
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(icon, color: IconStyles.defaultColor(context))),
            ),
            Expanded(
              flex: _settingNameFlex,
              child: Text(name,
                  maxLines: 2,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.settingsTitleStyle),
            ),
            Expanded(
              flex: _settingOpenFlex,
              child: const Center(child: Text(">")),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dividerRow(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: _settingIconFlex,
          child: Container(),
        ),
        Expanded(
          flex: _settingNameFlex,
          child: _divider(context),
        ),
        Expanded(
          flex: _settingOpenFlex,
          child: _divider(context),
        ),
      ],
    );
  }

  Widget _divider(BuildContext context) {
    return const Divider(
      thickness: 1,
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
