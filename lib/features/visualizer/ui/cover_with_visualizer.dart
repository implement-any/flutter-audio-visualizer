import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/blurhash_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/circle_bars_painter.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/cover_image.dart';

class CoverWithVisualizer extends ConsumerStatefulWidget {
  final AudioController audio;
  final VisualizerData visualizer;
  final Music music;

  const CoverWithVisualizer({
    super.key,
    required this.audio,
    required this.visualizer,
    required this.music,
  });

  @override
  ConsumerState<CoverWithVisualizer> createState() => _CoverWithVisualizerState();
}

class _CoverWithVisualizerState extends ConsumerState<CoverWithVisualizer> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _frame = ValueNotifier<double>(0);
  final ValueNotifier<double> _fade = ValueNotifier<double>(0);

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  Duration _basePosition = Duration.zero;
  double _fadeTarget = 1.0;
  int _baseMicros = 0;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _initAudioPosition();
    _initAudioListener();
    _initTicker();
  }

  void _initAudioPosition() {
    _positionSub = widget.audio.positionStream.listen((position) {
      _basePosition = position;
      _baseMicros = DateTime.now().microsecondsSinceEpoch;
    });
  }

  void _initAudioListener() {
    widget.audio.playingStream.listen((state) {
      _playing = state.playing;
      if(state.processingState == ProcessingState.completed) {
        _basePosition = Duration.zero;
        _baseMicros = DateTime.now().microsecondsSinceEpoch;
        _frame.value = 0;
      }
    });
    _stateSub = widget.audio.playingStream.listen((state) {
      final playing = state.playing;
      final completed = state.processingState == ProcessingState.completed;
      _fadeTarget = (playing && !completed) ? 1.0 : 0.0;
      if(completed) _frame.value = 0.0;
    });
  }

  void _initTicker() {
    void linearFrameIndex(VisualizerData? visualizer) {
      if (visualizer == null) return;
      final now = DateTime.now().microsecondsSinceEpoch;
      final elapsed = Duration(microseconds: now - _baseMicros);
      final estimatedPosition = _playing ? (_basePosition + elapsed) : _basePosition;
      final index = estimatedPosition.inMilliseconds / visualizer.meta.frameDurationMs;
      final clamped = index.clamp(0.0, (visualizer.meta.frameCount - 1).toDouble());
      if ((clamped - _frame.value).abs() > 0.0001) _frame.value = clamped;
    }

    void linearFade() {
      const power = 0.18;
      final nextFade = _fade.value + (_fadeTarget - _fade.value) * power;
      if((nextFade - _fade.value).abs() > 0.0005) {
        _fade.value = nextFade;
      } else {
        _fade.value = _fadeTarget;
      }
    }

    _ticker = createTicker((_) {
      final visualizer = ref.read(visualizerDataProvider(widget.music.audioId)).value;
      linearFade();
      linearFrameIndex(visualizer);
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    _fade.dispose();
    _positionSub?.cancel();
    _stateSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(blurHashProvider(widget.music.blurHash));

    const coverSize = 200.0;
    const maxLen = 20.0;
    const gap = 10.0;
    final size = coverSize + (maxLen + gap) * 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          IgnorePointer(
            child: RepaintBoundary(
              child: CustomPaint(
                size: Size(size, size),
                painter: CircleBarsPainter(
                  frameIndexListenable: _frame,
                  fadeListenable: _fade,
                  visualizer: widget.visualizer,
                  coverSize: coverSize,
                  gap: gap,
                  maxLen: maxLen,
                  color: color,
                ),
              ),
            ),
          ),
          CoverImage(
            size: coverSize,
            blurHash: widget.music.blurHash,
            imageUrl: widget.music.cover,
            isCircle: true,
          ),
        ],
      ),
    );
  }
}
