import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/artwork_circle.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class VisualizerScreen extends StatefulWidget {
  const VisualizerScreen({super.key});

  @override
  State<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends State<VisualizerScreen> {
  final AudioController _controller = AudioController();

  @override
  void initState() {
    super.initState();
    _controller.setUrl("canto_ix_boss_1_battle_theme");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              StreamBuilder<PlayerState>(
                stream: _controller.playingStream,
                builder: (context, snapshot) {
                  final state = snapshot.data;
                  final processing = state?.processingState;
                  final isPlaying = state?.playing ?? false;
                  final isCompleted = processing == ProcessingState.completed;
                  return Player(
                    onPrev: () {},
                    onPlay: isCompleted
                        ? _controller.resetToPlay
                        : _controller.toggle,
                    onNext: () {},
                    isPlaying: isPlaying,
                    isCompleted: isCompleted,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
