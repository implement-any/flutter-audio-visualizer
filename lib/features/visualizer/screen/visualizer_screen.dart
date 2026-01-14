import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/core/theme/colors.dart';

import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/ui/cover_with_visualizer.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/background_blur.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';

class VisualizerScreen extends ConsumerStatefulWidget {
  final Music music;

  const VisualizerScreen({super.key, required this.music});

  @override
  ConsumerState<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends ConsumerState<VisualizerScreen> {
  final AudioController _audio = AudioController();

  @override
  void initState() {
    super.initState();
    _initAudioStream();
  }

  @override
  void dispose() {
    _audio.dispose();
    super.dispose();
  }

  void _initAudioStream() {
    _audio.setAudio(widget.music.audioId);
  }

  @override
  Widget build(BuildContext context) {
    final visualizerAsync = ref.watch(visualizerDataProvider(widget.music.audioId));

    return Scaffold(
      backgroundColor: BaseColor.black,
      body: SizedBox(
        width: double.infinity,
        child: Stack(
          alignment: Alignment.center,
          children: [
            BackgroundBlur(blurHash: widget.music.blurHash),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 25,
              children: [
                visualizerAsync.when(
                  data: (visualizer) => CoverWithVisualizer(
                    audio: _audio,
                    visualizer: visualizer,
                    music: widget.music,
                  ),
                  error: (err, stack) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                MusicInfo(
                  title: widget.music.title,
                  subTitle: widget.music.subTitle,
                ),
                StreamBuilder<PlayerState>(
                  stream: _audio.playingStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final processing = state?.processingState;
                    final playing = state?.playing ?? false;
                    final completed = processing == ProcessingState.completed;
                    return Player(
                      onPlay: completed ? _audio.resetToPlay : _audio.toggle,
                      playing: playing,
                      completed: completed,
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
