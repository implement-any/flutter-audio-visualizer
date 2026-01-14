import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/visualizer_painter.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/cover_image.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class AudioStatus extends StatelessWidget {
  final Music music;
  final AudioController controller;

  const AudioStatus({super.key, required this.music, required this.controller});

  @override
  Widget build(BuildContext context) {
    const coverSize = 200.0;
    const ringPadding = 18.0; // 커버 바깥 여유
    final ringSize = coverSize + ringPadding * 2;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 25,
      children: [
        SizedBox(
          width: ringSize,
          height: ringSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ✅ 뒤: 원형 링 비주얼라이저
              IgnorePointer(
                child: VisualizerRing(
                  audioId: music.audioId,
                  controller: controller,
                  size: ringSize,
                  coverSize: coverSize,
                ),
              ),

              // ✅ 앞: 커버
              CoverImage(
                size: coverSize,
                blurHash: music.blurHash,
                imageUrl: music.cover,
                isCircle: true,
              ),
            ],
          ),
        ),

        MusicInfo(
          title: music.title,
          subTitle: music.subTitle,
        ),

        StreamBuilder<PlayerState>(
          stream: controller.playingStream,
          builder: (context, snapshot) {
            final state = snapshot.data;
            final processing = state?.processingState;
            final isPlaying = state?.playing ?? false;
            final isCompleted = processing == ProcessingState.completed;

            return Player(
              onPlay: isCompleted ? controller.resetToPlay : controller.toggle,
              isPlaying: isPlaying,
              isCompleted: isCompleted,
            );
          },
        ),
      ],
    );
  }
}
