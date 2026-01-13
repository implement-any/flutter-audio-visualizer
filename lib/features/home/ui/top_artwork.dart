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
            blurHash: "L7973-RK0RV-S%tWVrT34m-E.9F%",
            imageUrl:
                "https://limbuscompany.wiki.gg/images/thumb/DanteStar.png/780px-DanteStar.png?e52927",
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
