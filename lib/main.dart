import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/visualizer/screen/visualizer_screen.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Visualizer App',
      theme: ThemeData(),
      home: const VisualizerScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
