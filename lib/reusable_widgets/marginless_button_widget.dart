import 'package:flutter/material.dart';

class MarginlessButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final EdgeInsets expand;

  const MarginlessButton({
    super.key,
    required this.child,
    required this.onTap,
    this.expand = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        // Visible widget – layout is based ONLY on this
        child,

        // Large invisible tap target on top
        Positioned(
          left: -expand.left,
          right: -expand.right,
          top: -expand.top,
          bottom: -expand.bottom,
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: onTap,
            child: const SizedBox.expand(), // <- gives it real size
          ),
        ),
      ],
    );
  }
}
