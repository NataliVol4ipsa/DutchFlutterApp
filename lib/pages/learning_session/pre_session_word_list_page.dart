import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/pages/learning_session/session_page.dart';
import 'package:dutch_app/pages/word_collections/dialogs/word_details_dialog.dart';
import 'package:dutch_app/styles/border_styles.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PreSessionWordListPage extends StatefulWidget {
  final LearningSessionManager flowManager;

  const PreSessionWordListPage({super.key, required this.flowManager});

  @override
  State<PreSessionWordListPage> createState() => _PreSessionWordListPageState();
}

class _PreSessionWordListPageState extends State<PreSessionWordListPage> {
  bool isLoading = true;
  Set<int> practicedWordIds = {};

  @override
  void initState() {
    super.initState();
    _loadPracticedWordsAsync();
  }

  Future<void> _loadPracticedWordsAsync() async {
    final service = context.read<WordProgressService>();
    final wordIds = widget.flowManager.words.map((w) => w.id).toList();
    final practiced = await service.getPracticedWordIdsAsync(wordIds);
    if (!mounted) return;
    setState(() {
      practicedWordIds = practiced;
      isLoading = false;
    });
  }

  Future<void> _startSession() async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            LearningSessionPage(flowManager: widget.flowManager),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _showWordDetails(Word word) async {
    await WordDetailsDialog.show(
      context: context,
      word: word,
      allowDeletion: false,
    );
  }

  Widget _buildNewBadge(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.tertiary,
        borderRadius: BorderRadius.circular(
          BorderStyles.smallBorderRadiusValue,
        ),
      ),
      child: Text(
        'NEW',
        style: TextStyle(
          color: Theme.of(context).colorScheme.onTertiary,
          fontWeight: FontWeight.bold,
          fontSize: 11,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildWordTile(BuildContext context, Word word) {
    final isPracticed = practicedWordIds.contains(word.id);
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: ContainerStyles.smallPaddingAmount,
        vertical: ContainerStyles.tinyPaddingAmount,
      ),
      child: Material(
        color: ContainerStyles.sectionColor(context),
        borderRadius: BorderRadius.circular(
          BorderStyles.smallBorderRadiusValue,
        ),
        child: InkWell(
          onTap: isPracticed ? null : () => _showWordDetails(word),
          borderRadius: BorderRadius.circular(
            BorderStyles.smallBorderRadiusValue,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: ContainerStyles.defaultPaddingAmount,
              vertical: ContainerStyles.smallPaddingAmount2,
            ),
            child: Row(
              children: [
                // Word info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        word.toDutchWordString(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              color: colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
                if (!isPracticed) ...[
                  _buildNewBadge(context),
                  const SizedBox(width: 8),
                  Icon(
                    Icons.chevron_right,
                    color: colorScheme.onSurfaceVariant,
                    size: 20,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWordList(BuildContext context) {
    final words = widget.flowManager.words;
    return ListView.builder(
      padding: const EdgeInsets.only(top: ContainerStyles.smallPaddingAmount),
      itemCount: words.length,
      itemBuilder: (context, index) {
        return _buildWordTile(context, words[index]);
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final total = widget.flowManager.words.length;
    final newCount = total - practicedWordIds.length;
    final reviewCount = practicedWordIds.length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        ContainerStyles.defaultPaddingAmount,
        ContainerStyles.smallPaddingAmount,
        ContainerStyles.defaultPaddingAmount,
        ContainerStyles.tinyPaddingAmount,
      ),
      child: Row(
        children: [
          _buildCountChip(
            context,
            label: '$total words',
            icon: Icons.list,
            color: Theme.of(context).colorScheme.secondaryContainer,
            textColor: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
          const SizedBox(width: 8),
          if (newCount > 0)
            _buildCountChip(
              context,
              label: '$newCount new',
              icon: Icons.fiber_new,
              color: Theme.of(context).colorScheme.tertiaryContainer,
              textColor: Theme.of(context).colorScheme.onTertiaryContainer,
            ),
          if (newCount > 0 && reviewCount > 0) const SizedBox(width: 8),
          if (reviewCount > 0)
            _buildCountChip(
              context,
              label: '$reviewCount review',
              icon: Icons.refresh,
              color: Theme.of(context).colorScheme.primaryContainer,
              textColor: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
        ],
      ),
    );
  }

  Widget _buildCountChip(
    BuildContext context, {
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          BorderStyles.smallBorderRadiusValue,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.all(ContainerStyles.defaultPaddingAmount),
          child: Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: _startSession,
                  style: ButtonStyles.largeWidePrimaryButtonStyle(context),
                  child: const Text('Start Session'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today's Words"),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!isLoading) _buildHeader(context),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildWordList(context),
          ),
          _buildStartButton(context),
        ],
      ),
    );
  }
}
