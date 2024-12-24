import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/material.dart';

class BaseExerciseLayout extends StatefulWidget {
  final Widget Function(BuildContext context) contentBuilder;
  final Widget Function(BuildContext context) footerBuilder;

  const BaseExerciseLayout(
      {required this.contentBuilder, required this.footerBuilder, super.key});

  @override
  State<BaseExerciseLayout> createState() => _BaseExerciseLayoutState();
}

class _BaseExerciseLayoutState extends State<BaseExerciseLayout> {
  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: ContainerStyles.containerPadding,
              child: widget.contentBuilder(context),
            ),
          ),
          Container(
            padding: ContainerStyles.containerPadding,
            child: widget.footerBuilder(context),
          ),
        ],
      ),
    );
  }
}
