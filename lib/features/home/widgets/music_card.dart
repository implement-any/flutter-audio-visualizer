import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_audio_visualizer/shared/common/url.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';

class MusicCard extends StatelessWidget {
  final Music music;

  const MusicCard({super.key, required this.music});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.all(Radius.circular(10)),
        child: Stack(
          children: [
            Positioned.fill(
              child: ShaderMask(
                shaderCallback: (bounds) => RadialGradient(
                  center: Alignment.center,
                  radius: 0.95,
                  colors: [Colors.transparent, Colors.black]
                ).createShader(bounds),
                blendMode: BlendMode.darken,
                child: BlurHash(
                  hash: music.blurHash,
                  image: "${CommonUrl.server}${music.cover}",
                  imageFit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, bottom: 8.0),
                child: Text(music.title, style: TextStyle(fontSize: 12)),
              )
            )
          ],
        ),
      ),
    );
  }
}
