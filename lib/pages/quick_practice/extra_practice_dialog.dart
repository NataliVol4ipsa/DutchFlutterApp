import 'package:dutch_app/domain/models/settings.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<ExtraPracticeSettings?> showExtraPracticeDialog(
  BuildContext context,
) async {
  final settingsService = context.read<SettingsService>();
  final currentExtraSettings =
      (await settingsService.getSettingsAsync()).extraPractice;

  if (!context.mounted) return null;

  return showDialog<ExtraPracticeSettings>(
    context: context,
    barrierDismissible: false,
    builder: (_) => _ExtraPracticeDialog(initial: currentExtraSettings),
  );
}

class _ExtraPracticeDialog extends StatefulWidget {
  final ExtraPracticeSettings initial;

  const _ExtraPracticeDialog({required this.initial});

  @override
  State<_ExtraPracticeDialog> createState() => _ExtraPracticeDialogState();
}

class _ExtraPracticeDialogState extends State<_ExtraPracticeDialog> {
  late bool _useWeakest;
  late bool _useTomorrow;
  late bool _useRecentlyLearned;
  late bool _useRandom;

  @override
  void initState() {
    super.initState();
    _useWeakest = widget.initial.useWeakestWords;
    _useTomorrow = widget.initial.useTomorrowsWords;
    _useRecentlyLearned = widget.initial.useRecentlyLearned;
    _useRandom = widget.initial.useRandomWords;
  }

  ExtraPracticeSettings get _currentSettings => ExtraPracticeSettings(
    useWeakestWords: _useWeakest,
    useTomorrowsWords: _useTomorrow,
    useRecentlyLearned: _useRecentlyLearned,
    useRandomWords: _useRandom,
  );

  bool get _hasSelection =>
      _useWeakest || _useTomorrow || _useRecentlyLearned || _useRandom;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return AlertDialog(
      title: const Text('Already practiced today'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You already practiced today. Want to start an optional extra practice?',
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          Text('Word selection:', style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          _BucketCheckbox(
            label: 'Weakest words',
            description: 'Words with the lowest success rate',
            value: _useWeakest,
            onChanged: (v) => setState(() => _useWeakest = v),
          ),
          _BucketCheckbox(
            label: "Tomorrow's words",
            description: 'Due within the next 24 hours',
            value: _useTomorrow,
            onChanged: (v) => setState(() => _useTomorrow = v),
          ),
          _BucketCheckbox(
            label: 'Recently learned',
            description: 'Words you reviewed most recently',
            value: _useRecentlyLearned,
            onChanged: (v) => setState(() => _useRecentlyLearned = v),
          ),
          _BucketCheckbox(
            label: 'Random words',
            description: 'A random mix (deterministic per day)',
            value: _useRandom,
            onChanged: (v) => setState(() => _useRandom = v),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(null),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed: _hasSelection
              ? () => Navigator.of(context).pop(_currentSettings)
              : null,
          child: const Text('Yes, let\'s go'),
        ),
      ],
    );
  }
}

class _BucketCheckbox extends StatelessWidget {
  final String label;
  final String description;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _BucketCheckbox({
    required this.label,
    required this.description,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(description, style: Theme.of(context).textTheme.bodySmall),
      value: value,
      onChanged: (v) => onChanged(v ?? false),
      controlAffinity: ListTileControlAffinity.leading,
    );
  }
}
