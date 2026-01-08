import 'package:flutter/material.dart';

import 'package:flutter_audio_visualizer/features/visualizer/widgets/artwork_circle.dart';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(child: Column(children: [
        ArtworkCircle()
      ])),
    );
  }
}
