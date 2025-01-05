import 'package:dutch_app/core/models/settings.dart';
import 'package:dutch_app/core/services/settings_service.dart';
import 'package:dutch_app/pages/settings/setting_tiles/setting_switch_tile_widget.dart';
import 'package:dutch_app/pages/settings/settings_section_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ThemeSettingsPage extends StatefulWidget {
  static const name = "Theme";
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  bool isLoading = true;

  late SettingsService settingSetvice;
  late Settings settings;

  get showUseDarkTheme => !settings.theme.useSystemMode;

  @override
  void initState() {
    super.initState();
    settingSetvice = context.read<SettingsService>();
    _loadSettingsAsync();
  }

  Future<void> _loadSettingsAsync() async {
    settings = await settingSetvice.getSettingsAsync();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onUseSystemThemeChangedAsync(bool useSystemMode) async {
    setState(() {
      settings.theme.useSystemMode = useSystemMode;
    });
    await settingSetvice.updateSettingsAsync(settings);
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

  Widget _buildThemeSettings(BuildContext context) {
    return SettingsSection(children: [
      SettingsSwitchTile(
          name: "Use system theme",
          onChanged: _onUseSystemThemeChangedAsync,
          isInitiallyEnabled: settings.theme.useSystemMode),
      if (showUseDarkTheme) const SettingsSwitchTile(name: "Use dark theme"),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
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
