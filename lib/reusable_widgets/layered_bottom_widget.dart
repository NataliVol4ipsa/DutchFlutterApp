import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

// widget in the bottom of screen that hides whatever is underneath it and shows content on its place
class LayeredBottom extends StatelessWidget {
  final Widget Function(BuildContext context) contentBuilder;
  const LayeredBottom({super.key, required this.contentBuilder});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Theme.of(context).colorScheme.surface,
        padding: const EdgeInsets.fromLTRB(ContainerStyles.defaultPadding, 60,
            ContainerStyles.defaultPadding, ContainerStyles.defaultPadding),
        child: contentBuilder(context),
      ),
    );
  }
}
