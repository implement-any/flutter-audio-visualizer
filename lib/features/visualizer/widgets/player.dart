import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class Player extends StatelessWidget {
  final void Function() onPlay;

  final bool isPlaying;
  final bool isCompleted;

  const Player({
    super.key,
    required this.onPlay,
    required this.isPlaying,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: BaseColor.black,
      shape: CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onPlay,
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Icon(
            size: 30,
            isPlaying && !isCompleted ? Icons.pause : Icons.play_arrow,
            color: BaseColor.white,
          ),
        ),
      ),
    );
  }
}
