import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/animation/fade_transition.dart';
import 'package:flutter_audio_visualizer/shared/widgets/loading/custom_indicator.dart';

import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/ui/cover_with_visualizer.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/music_info.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/player.dart';

class VisualizerScreen extends ConsumerStatefulWidget {
  final Music music;

  const VisualizerScreen({super.key, required this.music});

  @override
  ConsumerState<VisualizerScreen> createState() => _VisualizerScreenState();
}

class _VisualizerScreenState extends ConsumerState<VisualizerScreen> with SingleTickerProviderStateMixin {
  final AudioController _audio = AudioController();
  late final AnimationController _animation;
  late final CurvedAnimation _curved;

  @override
  void initState() {
    super.initState();
    _initAudioStream();
    _initAnimation();
    WidgetsBinding.instance.addPostFrameCallback((_) => _applyAppBar());
  }

  @override
  void dispose() {
    _audio.dispose();
    _animation.dispose();
    super.dispose();
  }

  void _applyAppBar() {
    ref.read(appBarOverrideProvider.notifier).state = AppBarOverride(
      title: "Limbus Company OST",
      centerTitle: false,
      actions: const [],
    );
  }

  void _initAnimation() {
    _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    _curved = CurvedAnimation(parent: _animation, curve: const Interval(0.3, 0.6, curve: Curves.easeOut));
    _animation.forward();
  }

  void _initAudioStream() {
    _audio.setAudio(widget.music.audioId);
  }

  @override
  Widget build(BuildContext context) {
    final visualizerAsync = ref.watch(
      visualizerDataProvider(widget.music.audioId),
    );

    const coverSize = 250.0;
    const maxLen = 40.0;
    const gap = 22.5;
    final size = coverSize + (maxLen + gap) * 2;

    return SizedBox(
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 25,
            children: [
              visualizerAsync.when(
                data: (visualizer) => CoverWithVisualizer(
                  audio: _audio,
                  visualizer: visualizer,
                  music: widget.music,
                  coverSize: coverSize,
                  maxLen: maxLen,
                  gap: gap,
                  size: size
                ),
                error: (err, stack) => const SizedBox.shrink(),
                loading: () => SizedBox(
                  width: size,
                  height: size,
                  child: const Center(child: CustomIndicator()),
                ),
              ),
              FadeAnimation(
                animation: _curved,
                startY: 5,
                child: MusicInfo(
                  title: widget.music.title,
                  subTitle: widget.music.subTitle,
                ),
              ),
              FadeAnimation(
                  animation: _curved,
                  startY: 5,
                  child: StreamBuilder<PlayerState>(
                    stream: _audio.playingStream,
                    builder: (context, snapshot) {
                      final state = snapshot.data;
                      final processing = state?.processingState;
                      final playing = state?.playing ?? false;
                      final completed = processing == ProcessingState.completed;
                      return Player(
                        onPlay: completed ? _audio.resetToPlay : _audio.toggle,
                        playing: playing,
                        completed: completed,
                      );
                    },
                  )
              )
            ],
          )
        ],
      ),
    );
  }
}
