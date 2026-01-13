import 'package:go_router/go_router.dart';
import 'package:flutter_audio_visualizer/features/home/screen/home_screen.dart';
import 'package:flutter_audio_visualizer/features/visualizer/screen/visualizer_screen.dart';

class Paths {
  static final home = "/home";
  static final visualizer = "/visualizer";
}

class CustomRouter {
  static final router = GoRouter(
    initialLocation: Paths.home,
    routes: [
      GoRoute(
        path: Paths.home,
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: Paths.visualizer,
        builder: (context, state) {
          return VisualizerScreen(audioId: state.extra as String);
        },
      ),
    ],
  );
}
