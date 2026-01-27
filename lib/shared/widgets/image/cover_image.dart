import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/shared/common/environment.dart';
import 'package:flutter_audio_visualizer/shared/widgets/image/hero_blurhash.dart';

class CoverImage extends StatelessWidget {
  final double size;

  final String hash;
  final String imageUrl;

  final bool isCircle;

  const CoverImage({
    super.key,
    required this.size,
    required this.hash,
    required this.imageUrl,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isCircle
          ? BorderRadius.circular(size / 2)
          : BorderRadius.circular(5),
      child: SizedBox(
        width: size,
        height: size,
        child: HeroBlurHash(
          hash: hash,
          image: "${Environment.baseUrl}$imageUrl",
          boxFit: BoxFit.cover,
        ),
      ),
    );
  }
}
