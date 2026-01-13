import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/router/custom_router.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: "Music visualizer",
      theme: ThemeData(colorScheme: ColorScheme.dark()),
      routerConfig: CustomRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}
