import 'package:flutter/material.dart';

class Blur extends StatelessWidget {
  final Color color;
  final double opacity;
  final BlendMode mode;

  final Widget child;

  const Blur({
    super.key,
    required this.color,
    this.opacity = 1.0,
    this.mode = BlendMode.darken,
    required this.child
  });

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        color.withAlpha((opacity.clamp(0.0, 1.0) * 255).round()),
        mode,
      ),
      child: child,
    );
  }
}
