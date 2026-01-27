import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter_audio_visualizer/core/router/router_fade.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_inset.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_background.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_scaffold.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';

import 'package:flutter_audio_visualizer/features/home/screen/home_screen.dart';
import 'package:flutter_audio_visualizer/features/visualizer/screen/visualizer_screen.dart';

class Paths {
  static final home = "/home";
  static final visualizer = "/visualizer";
}

class CustomRouter {
  static final _shellNavigationKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    initialLocation: Paths.home,
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigationKey,
        builder: (context, state, child) => Stack(
          children: [
            ShellBackground(),
            ShellScaffold(shellNavigationKey: _shellNavigationKey, child: child),
          ],
        ),
        routes: [
          GoRoute(
            path: Paths.home,
            pageBuilder: (context, state) {
              return RouterCustomTransition.page(const AppbarInset(child: HomeScreen()));
            },
          ),
          GoRoute(
            path: Paths.visualizer,
            pageBuilder: (context, state) {
              final music = state.extra as Music;
              return RouterCustomTransition.page(VisualizerScreen(music: music));
            },
          ),
        ],
      ),
    ],
  );
}
