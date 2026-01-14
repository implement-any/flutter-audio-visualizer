import 'dart:ui';
import 'dart:typed_data';

import 'package:blurhash_dart/blurhash_dart.dart';

Uint8List decodeBlurHashToRgba(String blurHash, {int width = 32, int height = 32}) {
  final hash = BlurHash.decode(blurHash);
  return hash.toImage(width, height).getBytes();
}

Color colorFromBlurHash(String blurHash) {
  const size = 32;
  final rgba = decodeBlurHashToRgba(blurHash, width: size, height: size);

  final start = (size * 0.25).floor();
  final end = (size * 0.75).floor();

  int r = 0, g = 0, b = 0, count = 0;

  for(int y = start; y < end; y++) {
    for (int x = start; x < end; x++) {
      final i = (y * size + x) * 4;
      r += rgba[i];
      g += rgba[i + 1];
      b += rgba[i + 2];
      count++;
    }
  }

  return Color.fromARGB(255, r ~/ count, g ~/ count, b ~/ count);
}