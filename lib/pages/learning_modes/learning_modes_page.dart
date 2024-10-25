import 'package:first_project/core/types/learning_mode_type.dart';
import 'package:flutter/material.dart';

class LearningModesPage extends StatefulWidget {
  const LearningModesPage({super.key});

  @override
  State<LearningModesPage> createState() => _LearningModesPageState();
}

Widget customPadding() => const SizedBox(height: 10);

class _LearningModesPageState extends State<LearningModesPage> {
  List<LearningModeType> learningModes = LearningModeType.values.toList();
  final Set<LearningModeType> selectedModes = {};

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Learning Modes')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: learningModes.length,
                itemBuilder: (context, index) {
                  LearningModeType mode = learningModes[index];
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
                            ? colorScheme.primary.withOpacity(0.3)
                            : colorScheme.surface,
                        textColor: isSelected
                            ? colorScheme.onPrimary
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
              child: ElevatedButton(
                onPressed: selectedModes.isNotEmpty
                    ? () {
                        // Handle the start action with selected modes
                        print('Selected Modes: $selectedModes');
                      }
                    : null,
                child: const Text('Start'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
