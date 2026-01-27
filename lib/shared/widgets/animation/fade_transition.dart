import 'package:flutter/material.dart';

class FadeAnimation extends AnimatedWidget {
  final double startX;
  final double startY;

  final Animation animation;

  final Widget _child;

  const FadeAnimation({
    super.key,
    this.startX = 0,
    this.startY = 0,
    required this.animation,
    required child,
  }) : _child = child, super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final double dx = startX - startX * animation.value;
    final double dy = startY - startY * animation.value;

    return Transform.translate(
      offset: Offset(dx, dy),
      child: Opacity(opacity: animation.value, child: _child),
    );
  }
}
