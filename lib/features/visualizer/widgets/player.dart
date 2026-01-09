import 'package:flutter/material.dart';

class Player extends StatelessWidget {
  final void Function() onPlay;
  final void Function() onPrev;
  final void Function() onNext;

  final bool isPlaying;

  const Player({
    super.key,
    required this.onPlay,
    required this.onPrev,
    required this.onNext,
    required this.isPlaying,
  });

  @override
  Widget build(BuildContext context) {
    return IconTheme(
      data: const IconThemeData(size: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 10,
        children: [
          GestureDetector(onTap: onPrev, child: Icon(Icons.skip_previous)),
          Material(
            color: Colors.black,
            shape: CircleBorder(),
            child: InkWell(
              customBorder: const CircleBorder(),
              onTap: onPlay,
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Icon(
                  isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          GestureDetector(onTap: onNext, child: Icon(Icons.skip_next)),
        ],
      ),
    );
  }
}
