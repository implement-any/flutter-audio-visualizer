import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

class Artwork extends StatelessWidget {
  final String blurHash;
  final String imageUrl;

  const Artwork({super.key, required this.blurHash, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return BlurHash(hash: blurHash, image: imageUrl, imageFit: BoxFit.cover);
  }
}
