import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellBackground extends ConsumerWidget {
  const ShellBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blurHash = ref.watch(backgroundConfigProvider);

    return Positioned.fill(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(
          Colors.black.withAlpha(180),
          BlendMode.darken,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: blurHash.isEmpty
              ? const SizedBox.shrink()
              : BlurHash(key: ValueKey(blurHash), hash: blurHash),
        ),
      )
    );
  }
}
