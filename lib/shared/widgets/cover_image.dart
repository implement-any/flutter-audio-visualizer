import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_audio_visualizer/shared/common/url.dart';

class CoverImage extends StatelessWidget {
  final double size;

  final String blurHash;
  final String imageUrl;

  final bool isCircle;

  const CoverImage({
    super.key,
    required this.size,
    required this.blurHash,
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
        child: BlurHash(
          hash: blurHash,
          image: "${CommonUrl.server}$imageUrl",
          imageFit: BoxFit.cover,
        ),
      ),
    );
  }
}