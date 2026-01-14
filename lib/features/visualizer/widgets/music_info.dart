import 'package:flutter/material.dart';

import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class MusicInfo extends StatelessWidget {
  final String title;
  final String subTitle;

  const MusicInfo({super.key, required this.title, required this.subTitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 47,
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: BaseColor.white,
            ),
          ),
          Text(
            subTitle,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: BaseColor.white.withAlpha(150),
            ),
          ),
        ],
      ),
    );
  }
}
