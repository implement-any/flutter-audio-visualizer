import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/theme/colors.dart';
import 'package:flutter_audio_visualizer/features/home/widgets/artwork.dart';
import 'package:flutter_audio_visualizer/features/home/widgets/artwork_shadow.dart';
import 'package:flutter_audio_visualizer/features/home/widgets/artwork_title.dart';

class TopArtwork extends StatelessWidget {
  const TopArtwork({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        children: [
          Artwork(
            blurHash: r"L6BV;8OZ0N$K~Vs,M|Rn01w]WCI=",
            imageUrl:
            "https://i.ytimg.com/vi/WFUpe63YKW8/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLDq9dMjsspN3FaJzsxerlboZ7kFXw",
          ),
          ArtworkShadow(
            colors: [
              BaseColor.black,
              BaseColor.black.withAlpha(230),
              BaseColor.black.withAlpha(130),
              BaseColor.black.withAlpha(50),
              Colors.transparent,
            ],
            stops: const [0.05, 0.1, 0.2, 0.3, 0.4],
          ),
          ArtworkTitle(title: "림버스 컴퍼니 테마 곡 목록"),
        ],
      ),
    );
  }
}
