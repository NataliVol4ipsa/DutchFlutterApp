import 'package:dutch_app/core/audio/word_audio_service.dart';
import 'package:dutch_app/pages/settings/dialogs/show_audio_download_dialog.dart';
import 'package:dutch_app/pages/settings/dialogs/show_clear_audio_cache_dialog.dart';
import 'package:dutch_app/pages/settings/setting_tiles/setting_tile_widget.dart';
import 'package:dutch_app/pages/settings/settings_section_widget.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class DataSettingsPage extends StatefulWidget {
  static const name = "Data";

  const DataSettingsPage({super.key});

  @override
  State<DataSettingsPage> createState() => _DataSettingsPageState();
}

class _DataSettingsPageState extends State<DataSettingsPage> {
  String? _cacheSizeLabel;

  @override
  void initState() {
    super.initState();
    _loadCacheSize();
  }

  Future<void> _loadCacheSize() async {
    final bytes = await WordAudioService.getCacheSizeBytes();
    if (!mounted) return;
    setState(() {
      _cacheSizeLabel = WordAudioService.formatCacheSize(bytes);
    });
  }

  void _onClearAudioCache() {
    showClearAudioCacheDialog(
      context: context,
      callback: () async {
        await _loadCacheSize();
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Audio cache cleared")));
      },
    );
  }

  Future<void> _onDownloadMissingAudios() async {
    await showDownloadMissingAudiosDialog(context);
    await _loadCacheSize();
  }

  Future<void> _onUpdateExistingAudios() async {
    await showUpdateExistingAudiosDialog(context);
    await _loadCacheSize();
  }

  Widget _buildSettings(BuildContext context) {
    final List<Widget> sections = [_buildAudioSection(context)];

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

  Widget _buildAudioSection(BuildContext context) {
    return SettingsSection(
      useShortDivider: true,
      children: [
        _buildClearCacheTile(context),
        _buildDownloadMissingAudiosTile(context),
        _buildUpdateExistingAudiosTile(context),
      ],
    );
  }

  Widget _buildClearCacheTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderStyles.bigBorderRadius,
        ),
        onTap: _onClearAudioCache,
        child: SettingTile(
          name: "Clear audio cache",
          subtitle: _cacheSizeLabel,
          actionWidget: Center(
            child: Icon(
              Icons.delete_outline,
              size: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDownloadMissingAudiosTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderStyles.bigBorderRadius,
        ),
        onTap: _onDownloadMissingAudios,
        child: SettingTile(
          name: "Download missing audios",
          subtitle: "Fetch audios for words that have none",
          actionWidget: Center(
            child: Icon(
              Icons.download_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateExistingAudiosTile(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderStyles.bigBorderRadius,
        ),
        onTap: _onUpdateExistingAudios,
        child: SettingTile(
          name: "Update existing audios",
          subtitle: "Re-download audios already on this device",
          actionWidget: Center(
            child: Icon(
              Icons.refresh,
              size: 18,
              color: Theme.of(context).colorScheme.outline,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "${DataSettingsPage.name} Settings",
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
