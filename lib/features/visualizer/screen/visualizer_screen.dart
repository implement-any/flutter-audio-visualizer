import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/artwork_circle.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class VisualizerScreen extends ConsumerStatefulWidget {
  final String audioId;

  const VisualizerScreen({super.key, required this.audioId});

  @override
  ConsumerState<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends ConsumerState<VisualizerScreen> {
  final AudioController _controller = AudioController();

  @override
  void initState() {
    super.initState();
    _controller.setAudio(widget.audioId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final meta = ref.watch(
      visualizerMetaProvider(widget.audioId),
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
