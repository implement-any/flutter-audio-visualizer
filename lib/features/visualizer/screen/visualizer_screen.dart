import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/artwork_circle.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class VisualizerScreen extends ConsumerStatefulWidget {
  const VisualizerScreen({super.key});

  @override
  ConsumerState<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends ConsumerState<VisualizerScreen> {
  final AudioController _controller = AudioController();

  @override
  void initState() {
    super.initState();
    _controller.setAudio("canto_ix_boss_1_battle_theme");
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meta = ref.watch(
      visualizerMetaProvider("canto_ix_boss_1_battle_theme"),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              const ArtworkCircle(),
              SizedBox(
                height: 47,
                child: meta.when(
                  data: (meta) {
                    return MusicInfo(
                      title: meta.audio,
                      subTitle: "Project Moon",
                    );
                  },
                  error: (err, stack) => const Text("에러"),
                  loading: () => const CircularProgressIndicator(),
                ),
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
