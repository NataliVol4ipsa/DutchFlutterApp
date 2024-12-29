import 'package:first_project/styles/container_styles.dart';
import 'package:flutter/widgets.dart';

class SectionContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;
  final AlignmentGeometry? alignment;
  final Decoration? decoration;
  final BoxDecoration? boxDecoration;
  final Color? color;
  final BoxConstraints? constraints;

  const SectionContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.alignment,
    this.decoration,
    this.boxDecoration,
    this.color,
    this.constraints,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      margin: margin,
      width: width ?? double.infinity,
      height: height,
      alignment: alignment,
      decoration: decoration ??
          boxDecoration ??
          ContainerStyles.roundedEdgesDecoration(context),
      constraints: constraints,
      child: child,
    );
  }
}
