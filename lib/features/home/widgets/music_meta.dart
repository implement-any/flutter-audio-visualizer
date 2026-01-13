import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class MusicMeta extends StatelessWidget {
  final String title;
  final String subTitle;

  const MusicMeta({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(color: BaseColor.white)),
        Text(subTitle, style: TextStyle(color: BaseColor.white)),
      ],
    );
  }
}
