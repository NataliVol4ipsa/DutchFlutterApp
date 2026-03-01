import 'package:flutter/material.dart';

class ImportProgressDialog extends StatefulWidget {
  final Future<void> importFuture;
  final ValueNotifier<(int, int)> progressNotifier;

  const ImportProgressDialog({
    required this.importFuture,
    required this.progressNotifier,
    super.key,
  });

  @override
  State<ImportProgressDialog> createState() => _ImportProgressDialogState();
}

class _ImportProgressDialogState extends State<ImportProgressDialog> {
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    widget.importFuture
        .then((_) {
          if (mounted) Navigator.of(context).pop(true);
        })
        .catchError((Object e) {
          if (mounted) setState(() => _errorMessage = e.toString());
        });
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) {
      return AlertDialog(
        title: const Text('Import failed'),
        content: SingleChildScrollView(child: Text(_errorMessage!)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('CLOSE'),
          ),
        ],
      );
    }

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: const Text('Importing words…'),
        content: ValueListenableBuilder<(int, int)>(
          valueListenable: widget.progressNotifier,
          builder: (context, progress, _) {
            final (processed, total) = progress;
            if (total == 0) {
              return const SizedBox(
                width: 240,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Preparing…'),
                    SizedBox(height: 16),
                    LinearProgressIndicator(),
                  ],
                ),
              );
            }

            final percent = processed / total;
            return SizedBox(
              width: 240,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LinearProgressIndicator(value: percent),
                  const SizedBox(height: 12),
                  Text(
                    '$processed / $total words',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
