import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

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
          image: "http://10.0.2.2:8080$imageUrl",
          imageFit: BoxFit.cover,
        ),
      ),
    );
  }
}
