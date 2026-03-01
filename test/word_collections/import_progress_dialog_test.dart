/// Widget tests for [ImportProgressDialog].
///
/// These are pure widget tests — no Isar, no real import, no mocks needed.
/// A [Completer] controls the fake import future and a [ValueNotifier]
/// drives the progress updates so every dialog state can be exercised.
///
/// How to run:
///   flutter test test/word_collections/import_progress_dialog_test.dart
library;

import 'dart:async';

import 'package:dutch_app/pages/word_collections/dialogs/import_progress_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

// ── Helpers ──────────────────────────────────────────────────────────────────

/// Pumps [ImportProgressDialog] inside a minimal [MaterialApp] and returns
/// the captured pop result via [resultCompleter].
Future<void> _pumpDialog(
  WidgetTester tester, {
  required Future<void> importFuture,
  required ValueNotifier<(int, int)> notifier,
  required Completer<Object?> resultCompleter,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) {
          // Open the dialog immediately on first frame.
          WidgetsBinding.instance.addPostFrameCallback((_) {
            showDialog<bool>(
              context: context,
              barrierDismissible: false,
              builder: (_) => ImportProgressDialog(
                importFuture: importFuture,
                progressNotifier: notifier,
              ),
            ).then((result) => resultCompleter.complete(result));
          });
          return const Scaffold(body: SizedBox.shrink());
        },
      ),
    ),
  );
  // pump() instead of pumpAndSettle() to avoid timeout when an indeterminate
  // LinearProgressIndicator is present (it animates indefinitely).
  await tester.pump();
  await tester.pump();
}

// ── Tests ─────────────────────────────────────────────────────────────────────

void main() {
  // ── 1. Initial "Preparing…" state ─────────────────────────────────────────

  testWidgets('shows Preparing… and indeterminate bar when total is 0', (
    tester,
  ) async {
    final completer = Completer<void>();
    final notifier = ValueNotifier<(int, int)>((0, 0));
    final resultCompleter = Completer<Object?>();

    await _pumpDialog(
      tester,
      importFuture: completer.future,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );

    expect(find.text('Importing words…'), findsOneWidget);
    expect(find.text('Preparing…'), findsOneWidget);
    // Indeterminate LinearProgressIndicator has value == null.
    final indicator = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(indicator.value, isNull);

    // Clean up — complete the future so the dialog closes.
    completer.complete();
    await tester.pumpAndSettle();
    notifier.dispose();
  });

  // ── 2. Progress counter and determinate bar ───────────────────────────────

  testWidgets('shows X / Y words and determinate bar for in-progress state', (
    tester,
  ) async {
    final completer = Completer<void>();
    final notifier = ValueNotifier<(int, int)>((0, 100));
    final resultCompleter = Completer<Object?>();

    await _pumpDialog(
      tester,
      importFuture: completer.future,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );

    expect(find.text('0 / 100 words'), findsOneWidget);
    final before = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(before.value, 0.0);

    // Advance progress to halfway.
    notifier.value = (50, 100);
    await tester.pump();

    expect(find.text('50 / 100 words'), findsOneWidget);
    final halfway = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(halfway.value, closeTo(0.5, 0.001));

    // Advance to complete.
    notifier.value = (100, 100);
    await tester.pump();
    expect(find.text('100 / 100 words'), findsOneWidget);
    final full = tester.widget<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(full.value, closeTo(1.0, 0.001));

    completer.complete();
    await tester.pumpAndSettle();
    notifier.dispose();
  });

  // ── 3. Not dismissable while in progress ─────────────────────────────────

  testWidgets('dialog cannot be dismissed with back gesture while importing', (
    tester,
  ) async {
    final completer = Completer<void>();
    final notifier = ValueNotifier<(int, int)>((10, 100));
    final resultCompleter = Completer<Object?>();

    await _pumpDialog(
      tester,
      importFuture: completer.future,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );

    // Simulate Android back button.
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    // Dialog should still be visible.
    expect(find.text('Importing words…'), findsOneWidget);
    expect(resultCompleter.isCompleted, isFalse);

    completer.complete();
    await tester.pumpAndSettle();
    notifier.dispose();
  });

  // ── 4. Success: dialog auto-closes and pops true ─────────────────────────

  testWidgets('pops true when future completes successfully', (tester) async {
    final completer = Completer<void>();
    final notifier = ValueNotifier<(int, int)>((0, 5));
    final resultCompleter = Completer<Object?>();

    await _pumpDialog(
      tester,
      importFuture: completer.future,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );

    notifier.value = (5, 5);
    completer.complete();
    await tester.pumpAndSettle();

    // Dialog should be gone.
    expect(find.text('Importing words…'), findsNothing);
    expect(await resultCompleter.future, isTrue);
    notifier.dispose();
  });

  // ── 5. Failure: shows error message and CLOSE button ─────────────────────

  testWidgets('shows error state when future throws', (tester) async {
    final notifier = ValueNotifier<(int, int)>((3, 10));
    final resultCompleter = Completer<Object?>();

    // Delay via a timer so the error fires only after the widget mounts and
    // its catchError handler is registered.
    final errorFuture = Future<void>.delayed(
      Duration.zero,
      () => throw Exception('DB write failed'),
    );
    await _pumpDialog(
      tester,
      importFuture: errorFuture,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );
    // Advance the fake timer so the delayed future fires, then let setState rebuild.
    await tester.pump(const Duration(milliseconds: 1));
    await tester.pump();

    expect(find.text('Import failed'), findsOneWidget);
    expect(find.textContaining('DB write failed'), findsOneWidget);
    expect(find.text('CLOSE'), findsOneWidget);
    // Progress dialog content should be gone.
    expect(find.text('Importing words…'), findsNothing);

    // Tapping CLOSE pops false.
    await tester.tap(find.text('CLOSE'));
    await tester.pumpAndSettle();

    expect(find.text('Import failed'), findsNothing);
    expect(await resultCompleter.future, isFalse);
    notifier.dispose();
  });

  // ── 6. Progress notifier updates are reflected live ──────────────────────

  testWidgets('notifier value changes update UI without restarting dialog', (
    tester,
  ) async {
    final completer = Completer<void>();
    final notifier = ValueNotifier<(int, int)>((0, 200));
    final resultCompleter = Completer<Object?>();

    await _pumpDialog(
      tester,
      importFuture: completer.future,
      notifier: notifier,
      resultCompleter: resultCompleter,
    );

    for (var i = 0; i <= 200; i += 50) {
      notifier.value = (i, 200);
      await tester.pump();
      expect(find.text('$i / 200 words'), findsOneWidget);
    }

    completer.complete();
    await tester.pumpAndSettle();
    notifier.dispose();
  });
}
