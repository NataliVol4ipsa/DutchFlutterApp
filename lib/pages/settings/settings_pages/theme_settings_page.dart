import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
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

  late DarkThemeToggledNotifier darkThemeNotifier;

  get showUseDarkTheme => !settings.theme.useSystemMode;

  @override
  void initState() {
    super.initState();
    settingSetvice = context.read<SettingsService>();
    darkThemeNotifier =
        Provider.of<DarkThemeToggledNotifier>(context, listen: false);
    _loadSettingsAsync();
  }

  Future<void> _loadSettingsAsync() async {
    settings = await settingSetvice.getSettingsAsync();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _onUseSystemModeChangedAsync(bool useSystemMode) async {
    setState(() {
      settings.theme.useSystemMode = useSystemMode;
    });
    await settingSetvice.updateSettingsAsync(settings);
    _notifyThemeChanges();
  }

  Future<void> _onUseDarkModeChangedAsync(bool useDarkMode) async {
    setState(() {
      settings.theme.useDarkMode = useDarkMode;
    });
    await settingSetvice.updateSettingsAsync(settings);
    _notifyThemeChanges();
  }

  void _notifyThemeChanges() {
    Brightness platformBrightness = MediaQuery.of(context).platformBrightness;
    bool useDarkTheme = DarkThemeToggledNotifier.shouldUseDarkTheme(
        settings.theme.useSystemMode,
        settings.theme.useDarkMode,
        platformBrightness);

    darkThemeNotifier.setDarkTheme(useDarkTheme);
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
          onChanged: _onUseSystemModeChangedAsync,
          isInitiallyEnabled: settings.theme.useSystemMode),
      if (showUseDarkTheme)
        SettingsSwitchTile(
            name: "Use dark theme",
            onChanged: _onUseDarkModeChangedAsync,
            isInitiallyEnabled: settings.theme.useDarkMode),
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
