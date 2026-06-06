import 'package:dutch_app/domain/services/audio_bulk_download_service.dart';
import 'package:flutter/material.dart';

class AudioDownloadDialog extends StatefulWidget {
  final AudioBulkDownloadService service;
  final AudioDownloadMode mode;

  const AudioDownloadDialog({
    super.key,
    required this.service,
    required this.mode,
  });

  @override
  State<AudioDownloadDialog> createState() => _AudioDownloadDialogState();
}

class _AudioDownloadDialogState extends State<AudioDownloadDialog> {
  AudioBulkDownloadPhase _phase = AudioBulkDownloadPhase.preparing;
  int _total = 0;
  int _done = 0;

  AudioBulkDownloadResult? _result;
  bool _cancelled = false;

  @override
  void initState() {
    super.initState();
    _start();
  }

  Future<void> _start() async {
    final words = await widget.service.getWordsForModeAsync(widget.mode);
    if (!mounted || _cancelled) return;

    setState(() {
      _total = words.length;
      _phase = AudioBulkDownloadPhase.downloading;
    });

    final result = await widget.service.downloadAllAsync(
      words: words,
      onProgress: (done, total) {
        if (!mounted || _cancelled) return;
        setState(() {
          _done = done;
          _total = total;
        });
      },
      isCancelled: () => _cancelled,
    );

    if (!mounted || _cancelled) return;
    setState(() {
      _result = result;
      _phase = AudioBulkDownloadPhase.done;
    });
  }

  String get _title {
    if (_phase == AudioBulkDownloadPhase.done) return 'Download complete!';
    return 'Download audios';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_title),
      content: _buildContent(context),
      actions: _buildActions(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (_phase) {
      case AudioBulkDownloadPhase.preparing:
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Analysing your library…',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
            const SizedBox(height: 12),
            const LinearProgressIndicator(),
          ],
        );
      case AudioBulkDownloadPhase.downloading:
        final progress = _total == 0 ? 0.0 : _done / _total;
        return Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Fetching $_done of $_total…'),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progress),
          ],
        );
      case AudioBulkDownloadPhase.done:
        return _buildSummary(context);
    }
  }

  Widget _buildSummary(BuildContext context) {
    final result = _result!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.mode == AudioDownloadMode.missingOnly) ...[
          _summaryRow(
            context,
            Icons.add_circle_outline,
            'New audios downloaded: ${result.added.length}',
          ),
          const SizedBox(height: 6),
          _summaryRow(
            context,
            Icons.error_outline,
            'Unavailable: ${result.missing.length}',
          ),
        ],
        if (widget.mode == AudioDownloadMode.updateExisting) ...[
          _summaryRow(
            context,
            Icons.refresh,
            'Audios updated: ${result.updated.length}',
          ),
          const SizedBox(height: 6),
          _summaryRow(
            context,
            Icons.error_outline,
            'Unavailable: ${result.missing.length}',
          ),
        ],
      ],
    );
  }

  Widget _summaryRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
        const SizedBox(width: 8),
        Expanded(child: Text(text)),
      ],
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    switch (_phase) {
      case AudioBulkDownloadPhase.done:
        return [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ];
      case AudioBulkDownloadPhase.preparing:
      case AudioBulkDownloadPhase.downloading:
        return [
          TextButton(
            onPressed: () {
              _cancelled = true;
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ];
    }
  }
}
