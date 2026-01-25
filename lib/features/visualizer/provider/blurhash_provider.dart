import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/shared/utils/color/extract_blurhash.dart';

final blurHashProvider = Provider.family<Color, String>((ref, blurHash) {
  return colorFromBlurHash(blurHash);
});
