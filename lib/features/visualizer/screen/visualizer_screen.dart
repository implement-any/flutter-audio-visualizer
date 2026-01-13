import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/background_blur.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/cover_image.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class VisualizerScreen extends ConsumerStatefulWidget {
  final Music music;

  const VisualizerScreen({super.key, required this.music});

  @override
  ConsumerState<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends ConsumerState<VisualizerScreen> {
  final AudioController _controller = AudioController();

  @override
  void initState() {
    super.initState();
    _controller.setAudio(widget.music.audioId);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                CoverImage(
                  size: 200,
                  blurHash: widget.music.blurHash,
                  imageUrl: widget.music.cover,
                  isCircle: true,
                ),
                MusicInfo(
                  title: widget.music.title,
                  subTitle: widget.music.subTitle,
                ),
                StreamBuilder<PlayerState>(
                  stream: _controller.playingStream,
                  builder: (context, snapshot) {
                    final state = snapshot.data;
                    final processing = state?.processingState;
                    final isPlaying = state?.playing ?? false;
                    final isCompleted = processing == ProcessingState.completed;
                    return Player(
                      onPlay: isCompleted
                          ? _controller.resetToPlay
                          : _controller.toggle,
                      isPlaying: isPlaying,
                      isCompleted: isCompleted,
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
