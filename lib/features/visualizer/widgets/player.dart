import 'package:flutter/material.dart';

import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class Player extends StatelessWidget {
  final void Function() onPlay;

  final bool playing;
  final bool completed;

  const Player({
    super.key,
    required this.onPlay,
    required this.playing,
    required this.completed,
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
            playing && !completed ? Icons.pause : Icons.play_arrow,
            color: BaseColor.white,
          ),
        ),
      ),
    );
  }
}
