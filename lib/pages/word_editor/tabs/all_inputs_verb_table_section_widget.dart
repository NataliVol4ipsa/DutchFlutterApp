import 'package:dutch_app/styles/container_styles.dart';
import 'package:flutter/material.dart';

class AllInputsVerbTableSection extends StatelessWidget {
  const AllInputsVerbTableSection({
    super.key,
    required this.context,
    required this.title,
    required this.child,
  });

  final BuildContext context;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: ContainerStyles.defaultPaddingAmount,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.onSurfaceVariant.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.dividerColor.withOpacity(0.6),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(ContainerStyles.defaultPaddingAmount),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface.withOpacity(0.9),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
