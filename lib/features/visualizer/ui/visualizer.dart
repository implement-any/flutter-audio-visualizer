import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';

class Visualizer extends StatelessWidget {
  final String audioId;
  final AudioController controller;

  const Visualizer({super.key, required this.audioId, required this.controller});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
