import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/notifiers/dark_theme_toggled_notifier.dart';
import 'package:dutch_app/domain/services/practice_session_stateful_service.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/pages/settings/setting_tiles/setting_number_tile_widget.dart';
import 'package:dutch_app/pages/settings/setting_tiles/setting_switch_tile_widget.dart';
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
  bool isSessionActive = false;

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
    isSessionActive = context
        .read<PracticeSessionStatefulService>()
        .isSessionActive;
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

  void _onUseAnkiModeChanged(bool value) {
    setState(() {
      settings.session.useAnkiMode = value;
    });
    settingService.updateSettingsAsync(settings);
  }

  void _onShowPreSessionWordListChanged(bool value) {
    setState(() {
      settings.session.showPreSessionWordList = value;
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
      lockedHint: isSessionActive
          ? "Cannot be changed during an active session"
          : null,
      children: [
        SettingsSliderTile(
          name: "New words per session",
          minimumValue: 1,
          maximumValue: 10,
          initialValue: settings.session.newWordsPerSession.toDouble(),
          step: 1,
          isLocked: isSessionActive,
          onChanged: _onNewWordsPerSessionChanged,
        ),
        SettingsSliderTile(
          name: "Repetitions per session",
          minimumValue: 1,
          maximumValue: 30,
          initialValue: settings.session.repetitionsPerSession.toDouble(),
          step: 1,
          isLocked: isSessionActive,
          onChanged: _onRepetitionsPerSessionChanged,
        ),
        SettingsSwitchTile(
          name: "Anki-style grading",
          isInitiallyEnabled: settings.session.useAnkiMode,
          isLocked: isSessionActive,
          onChanged: _onUseAnkiModeChanged,
        ),
        SettingsSwitchTile(
          name: "Show word list before session",
          isInitiallyEnabled: settings.session.showPreSessionWordList,
          isLocked: false,
          onChanged: _onShowPreSessionWordListChanged,
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
