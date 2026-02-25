import 'package:dutch_app/core/local_db/repositories/words_repository.dart';
import 'package:dutch_app/domain/models/word.dart';
import 'package:dutch_app/domain/services/practice_session_stateful_service.dart';
import 'package:dutch_app/domain/services/settings_service.dart';
import 'package:dutch_app/domain/types/exercise_type.dart';
import 'package:dutch_app/domain/notifiers/exercise_answered_notifier.dart';
import 'package:dutch_app/pages/learning_session/pre_session_word_list_page.dart';
import 'package:dutch_app/pages/learning_session/session_manager.dart';
import 'package:dutch_app/pages/learning_session/session_page.dart';
import 'package:dutch_app/pages/learning_session/word_progress_service.dart';
import 'package:dutch_app/reusable_widgets/my_app_bar_widget.dart';
import 'package:dutch_app/styles/button_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExercisesSelectorPage extends StatefulWidget {
  const ExercisesSelectorPage({super.key});

  @override
  State<ExercisesSelectorPage> createState() => _ExercisesSelectorPageState();
}

Widget customPadding() => const SizedBox(height: 10);

class _ExercisesSelectorPageState extends State<ExercisesSelectorPage> {
  late WordsRepository wordsRepository;
  late SettingsService settingsService;

  List<ExerciseType> learningModes = ExerciseType.values.toList();
  final Set<ExerciseType> selectedModes = {};

  @override
  void initState() {
    super.initState();
    wordsRepository = context.read<WordsRepository>();
    settingsService = context.read<SettingsService>();
  }

  Future<void> onStartButtonClick() async {
    final settings = await settingsService.getSettingsAsync();
    final useAnkiMode = settings.session.useAnkiMode;
    final showPreSessionWordList = settings.session.showPreSessionWordList;
    if (!mounted) return;

    final service = context.read<PracticeSessionStatefulService>();
    final List<Word> words = service.words;
    final wordProgressService = Provider.of<WordProgressService>(
      context,
      listen: false,
    );
    final notifier = Provider.of<ExerciseAnsweredNotifier>(
      context,
      listen: false,
    );

    final flowManager = LearningSessionManager(
      selectedModes.toList(),
      words,
      wordProgressService,
      notifier,
      useAnkiMode: useAnkiMode,
    );
    if (!mounted) return;
    if (showPreSessionWordList) {
      _navigateToPreSessionWordListPage(context, flowManager);
    } else {
      navigateToLearningTaskPage(context, flowManager);
    }
  }

  Future<void> navigateToLearningTaskPage(
    BuildContext context,
    LearningSessionManager flowManager,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningSessionPage(flowManager: flowManager),
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }

  Future<void> _navigateToPreSessionWordListPage(
    BuildContext context,
    LearningSessionManager flowManager,
  ) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PreSessionWordListPage(flowManager: flowManager),
      ),
    );
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: const MyAppBar(title: Text('Select Learning Modes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: learningModes.length,
                itemBuilder: (context, index) {
                  ExerciseType mode = learningModes[index];
                  bool isSelected = selectedModes.contains(mode);

                  return Column(
                    children: [
                      ListTile(
                        title: Text(mode.label),
                        subtitle: Text(
                          mode.explanation,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        tileColor: isSelected
                            ? colorScheme.secondaryContainer
                            : colorScheme.surface,
                        textColor: isSelected
                            ? colorScheme.onSecondaryContainer
                            : colorScheme.onSurface,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedModes.remove(mode);
                            } else {
                              selectedModes.add(mode);
                            }
                          });
                        },
                      ),
                      customPadding(),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: selectedModes.isNotEmpty
                          ? () {
                              onStartButtonClick();
                            }
                          : null,
                      style: ButtonStyles.largeWidePrimaryButtonStyle(context),
                      child: const Text('Start'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
