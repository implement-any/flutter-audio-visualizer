import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/artwork_circle.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

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
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              ArtworkCircle(),
              MusicInfo(
                title: "Canto IX Boss Battle Theme",
                subTitle: "Project Moon",
              ),
              Player(
                onPrev: () {},
                onPlay: () {},
                onNext: () {},
                isPlaying: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
