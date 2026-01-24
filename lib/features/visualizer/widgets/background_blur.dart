import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';

import 'package:flutter_audio_visualizer/core/theme/colors.dart';

class BackgroundBlur extends StatelessWidget {
  final String blurHash;

  const BackgroundBlur({super.key, required this.blurHash});

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          BaseColor.black.withAlpha(190),
          BlendMode.darken,
        ),
        child: BlurHash(
          hash: blurHash,
          imageFit: BoxFit.cover,
        ),
      ),
    );
  }
}
