import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class HeroBlurHash extends StatelessWidget {
  final String hash;
  final String image;
  final BoxFit boxFit;
  final bool enabled;

  const HeroBlurHash({
    super.key,
    required this.hash,
    required this.image,
    this.boxFit = BoxFit.cover,
    this.enabled = false,
  });

  @override
  Widget build(BuildContext context) {
    return HeroMode(
      enabled: enabled,
      child: BlurHash(hash: hash, image: image, imageFit: boxFit),
    );
  }
}
