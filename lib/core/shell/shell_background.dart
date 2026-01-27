import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';
import 'package:flutter_audio_visualizer/shared/widgets/color/blur.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ShellBackground extends ConsumerWidget {
  const ShellBackground({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final background = ref.watch(backgroundConfigProvider);

    return Positioned.fill(
      child: Blur(
        color: Colors.black,
        opacity: 0.65,
        mode: BlendMode.darken,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 1000),
          child: KeyedSubtree(
            key: ValueKey("${background.hash}#${background.rev}"),
            child: background.hash.isEmpty ? const SizedBox.shrink() : BlurHash(hash: background.hash),
          )
        ),
      ),
    );
  }
}
