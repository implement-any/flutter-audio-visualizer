import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RouterCustomTransition {
  static Widget _reverseFadeTransition(
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
      child: child,
    );
  }

  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final fadeIn = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
    final fadeOut = CurvedAnimation(parent: secondaryAnimation, curve: Curves.easeInOut);
    
    return FadeTransition(
      opacity: fadeIn,
      child: _reverseFadeTransition(fadeOut, child),
    );
  }

  static CustomTransitionPage page(Widget child) {
    return CustomTransitionPage(
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: _fadeTransition,
    );
  }
}
