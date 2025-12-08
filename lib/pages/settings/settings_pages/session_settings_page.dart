import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/pages/settings/setting_tiles/setting_number_tile_widget.dart';
import 'package:dutch_app/pages/settings/settings_section_widget.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SessionSettingsPage extends StatefulWidget {
  static const name = "Learnin Session";
  const SessionSettingsPage({super.key});

  @override
  State<SessionSettingsPage> createState() => _SessionettingsPageState();
}

class _SessionettingsPageState extends State<SessionSettingsPage> {
  bool isLoading = true;

  late SettingsService settingService;
  late Settings settings;

  late DarkThemeToggledNotifier darkThemeNotifier;

  bool get showUseDarkTheme => !settings.theme.useSystemMode;

  @override
  void initState() {
    super.initState();
    settingService = context.read<SettingsService>();
    darkThemeNotifier = Provider.of<DarkThemeToggledNotifier>(
      context,
      listen: false,
    );
    _loadSettingsAsync();
  }

  Future<void> _loadSettingsAsync() async {
    settings = await settingService.getSettingsAsync();
    setState(() {
      isLoading = false;
    });
  }

  void _onNewWordsPerSessionChanged(double value) {
    setState(() {
      settings.session.newWordsPerSession = value.round();
    });
    settingService.updateSettingsAsync(settings);
  }

  void _onRepetitionsPerSessionChanged(double value) {
    setState(() {
      settings.session.repetitionsPerSession = value.round();
    });
    settingService.updateSettingsAsync(settings);
  }

  Widget _buildSettings(BuildContext context) {
    final List<Widget> sections = [_buildThemeSettings(context)];

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
      ),
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return SettingsSection(
      children: [
        SettingsSliderTile(
          name: "New words per session",
          minimumValue: 1,
          maximumValue: 10,
          initialValue: settings.session.newWordsPerSession.toDouble(),
          step: 1,
          onChanged: _onNewWordsPerSessionChanged,
        ),
        SettingsSliderTile(
          name: "Repetitions per session",
          minimumValue: 1,
          maximumValue: 30,
          initialValue: settings.session.repetitionsPerSession.toDouble(),
          step: 1,
          onChanged: _onRepetitionsPerSessionChanged,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "${SessionSettingsPage.name} Settings",
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: ContainerStyles.containerPadding,
        child: _buildSettings(context),
      ),
    );
  }
}
