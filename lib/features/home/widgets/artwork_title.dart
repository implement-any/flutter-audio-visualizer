import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class ArtworkTitle extends StatelessWidget {
  final String title;

  const ArtworkTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 15,
      bottom: 15,
      child: Text(
        title,
        style: TextStyle(fontSize: 20, color: BaseColor.white),
      ),
    );
  }
}
