import 'package:flutter/cupertino.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_background.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_scaffold.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/features/home/screen/home_screen.dart';
import 'package:flutter_audio_visualizer/features/visualizer/screen/visualizer_screen.dart';

class Paths {
  static final home = "/home";
  static final visualizer = "/visualizer";
}

class CustomRouter {
  static Widget _fadeTransition(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(
      opacity: animation,
      child: FadeTransition(
        opacity: ReverseAnimation(secondaryAnimation),
        child: child,
      ),
    );
  }

  static final router = GoRouter(
    initialLocation: Paths.home,
    routes: [
      ShellRoute(
        builder: (context, state, child) {
          return Stack(
            children: [
              ShellBackground(),
              ShellScaffold(child: child),
            ],
          );
        },
        routes: [
          GoRoute(
            path: Paths.home,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomeScreen(),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: _fadeTransition,
            ),
          ),
          GoRoute(
            path: Paths.visualizer,
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: VisualizerScreen(music: state.extra as Music),
              transitionDuration: const Duration(milliseconds: 300),
              reverseTransitionDuration: const Duration(milliseconds: 300),
              transitionsBuilder: _fadeTransition,
            ),
          ),
        ],
      ),
    ],
  );
}
