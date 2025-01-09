import 'package:flutter/material.dart';

class PaddedFormComponent extends StatelessWidget {
  final Widget child;
  const PaddedFormComponent({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: child,
    );
  }
}
