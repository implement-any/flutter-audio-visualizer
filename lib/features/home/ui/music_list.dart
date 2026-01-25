import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/fade_transition.dart';
import 'package:flutter_audio_visualizer/features/home/widgets/music_card.dart';

class MusicList extends ConsumerStatefulWidget {
  final AsyncValue<List<Music>> musicList;

  const MusicList({super.key, required this.musicList});

  @override
  ConsumerState<MusicList> createState() => _MusicListState();
}

class _MusicListState extends ConsumerState<MusicList> with SingleTickerProviderStateMixin {
  Timer? _timer;

  late final PageController _pageController;
  late final AnimationController _animation;
  late final CurvedAnimation _curved;

  void goVisualizer(Music music) async {
    await context.push("/visualizer", extra: music);
    _animation..reset()..forward();
  }

  void changeFocus(Music music) {
    final nextBlurHash = music.blurHash;
    final currentBlurHash = ref.read(backgroundConfigProvider);
    if(nextBlurHash.isEmpty) return;
    if(nextBlurHash == currentBlurHash) return;
    ref.read(backgroundConfigProvider.notifier).state = music.blurHash;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 1, viewportFraction: 0.55);
    _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _curved = CurvedAnimation(parent: _animation, curve: const Interval(0.3, 0.8, curve: Curves.easeIn));
    _animation.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animation.dispose();
    _curved.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.musicList.when(data: (musicList) {
      return FadeAnimation(
        animation: _curved,
        startY: 5,
        child: ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0, 0.05, 0.95, 1.0],
            colors: [Colors.black, Colors.transparent, Colors.transparent, Colors.black]
          ).createShader(bounds),
          blendMode: BlendMode.dstOut,
          child: PageView.builder(
            onPageChanged: (page) {
              changeFocus(musicList[page]);
            },
            controller: _pageController,
            physics: const BouncingScrollPhysics(parent: PageScrollPhysics()),
            itemCount: musicList.length,
            itemBuilder: (context, index) {
              final Music music = musicList[index];
              return AnimatedBuilder(
                animation: _pageController,
                builder: (context, child) {
                  final page = _pageController.page ?? index.toDouble();
                  final diff = (index - page).clamp(-1.0, 1.0);
                  final angle = diff * 0.5;
                  final matrix = Matrix4.identity()
                    ..setEntry(3, 3, 1) // 전체적인 scale 조정
                    ..setEntry(3, 0, 0.0025 * -diff) // 좌, 우 왜곡 ( / | \ )
                    ..translateByDouble(30 * -diff, 0, 0, 1) // 간격 조정
                    ..rotateY(-diff * angle);

                  return Transform(
                    transform: matrix,
                    alignment: FractionalOffset.center,
                    child: GestureDetector(
                      onTap: () {
                        if(diff == 0) goVisualizer(music);
                      },
                      child: Center(child: child),
                    ),
                  );
                },
                child: MusicCard(music: music)
              );
            },
          ),
        )
      );
    },
    error: (err, stack) => const Text("Error"),
    loading: () => const CircularProgressIndicator());
  }
}
