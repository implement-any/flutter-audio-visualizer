import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_audio_visualizer/shared/widgets/animation/fade_transition.dart';
import 'package:just_audio/just_audio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/blurhash_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/widgets/circle_bars_painter.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';
import 'package:flutter_audio_visualizer/shared/widgets/image/cover_image.dart';

class CoverWithVisualizer extends ConsumerStatefulWidget {
  final AudioController audio;
  final VisualizerData visualizer;
  final Music music;
  final double coverSize;
  final double maxLen;
  final double gap;
  final double size;

  const CoverWithVisualizer({
    super.key,
    required this.audio,
    required this.visualizer,
    required this.music,
    required this.coverSize,
    required this.maxLen,
    required this.gap,
    required this.size
  });

  @override
  ConsumerState<CoverWithVisualizer> createState() => _CoverWithVisualizerState();
}

class _CoverWithVisualizerState extends ConsumerState<CoverWithVisualizer> with TickerProviderStateMixin {
  late final Ticker _ticker;
  final ValueNotifier<double> _frame = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _fade = ValueNotifier<double>(0.0);
  final ValueNotifier<double> _rotation = ValueNotifier<double>(0.0);

  late final AnimationController _animation;
  late final CurvedAnimation _curved;

  StreamSubscription<Duration>? _positionSub;
  StreamSubscription<PlayerState>? _stateSub;

  Duration _basePosition = Duration.zero;
  double _rotationCount = 0.0;
  double _fadeTarget = 1.0;
  int _baseMicros = 0;
  bool _playing = false;
  bool _completed = false;

  @override
  void initState() {
    super.initState();
    _initAudioPosition();
    _initAudioListener();
    _initTicker();
    initAnimation();
  }

  void initAnimation() {
    _animation = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _curved = CurvedAnimation(parent: _animation, curve: const Interval(0.3, 0.6, curve: Curves.easeOut));
    _animation.forward();
  }

  void _initAudioPosition() {
    _positionSub = widget.audio.positionStream.listen((position) {
      _basePosition = position;
      _baseMicros = DateTime.now().microsecondsSinceEpoch;
    });
  }

  void _initAudioListener() {
    _stateSub = widget.audio.playingStream.listen((state) {
      _playing = state.playing;
      _completed = state.processingState == ProcessingState.completed;

      // Sick, Frame index 초기화
      if (_completed) {
        _basePosition = Duration.zero;
        _baseMicros = DateTime.now().microsecondsSinceEpoch;
        _frame.value = 0;
      }

      // 재생 중이거나 완료되지 않은 경우 기본 Bar 높이 1.0 아니라면 0.0
      _fadeTarget = (_playing && !_completed) ? 1.0 : 0.0;
    });
  }

  void _initTicker() {
    void linearFrameIndex(VisualizerData? visualizer) {
      if (visualizer == null) return;
      final now = DateTime.now().microsecondsSinceEpoch;
      final elapsed = Duration(microseconds: now - _baseMicros);
      final estimatedPosition = _playing ? (_basePosition + elapsed) : _basePosition;
      final index = estimatedPosition.inMilliseconds / visualizer.meta.frameDurationMs;
      final clamped = index.clamp(0.0, (visualizer.meta.frameCount - 1).toDouble(),);
      if ((clamped - _frame.value).abs() > 0.0001) _frame.value = clamped;
    }

    void linearFade() {
      const power = 0.18;
      final nextFade = _fade.value + (_fadeTarget - _fade.value) * power;
      if ((nextFade - _fade.value).abs() > 0.0005) {
        _fade.value = nextFade;
      } else {
        _fade.value = _fadeTarget;
      }
    }

    void rotating() {
      if (_playing && !_completed) {
        _rotationCount += 0.002;
        _rotation.value = _rotationCount;
      }
    }

    _ticker = createTicker((_) {
      final visualizer = ref.read(visualizerDataProvider(widget.music.audioId)).value;
      linearFade();
      linearFrameIndex(visualizer);
      rotating();
    })..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    _frame.dispose();
    _fade.dispose();
    _rotation.dispose();
    _positionSub?.cancel();
    _stateSub?.cancel();
    _animation.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = ref.watch(blurHashProvider(widget.music.blurHash));

    return FadeAnimation(
      animation: _curved,
      startY: 5,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: Stack(
          alignment: Alignment.center,
          children: [
            IgnorePointer(
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: CircleBarsPainter(
                    frameIndexListenable: _frame,
                    fadeListenable: _fade,
                    rotatable: _rotation,
                    visualizer: widget.visualizer,
                    coverSize: widget.coverSize,
                    gap: widget.gap,
                    maxLen: widget.maxLen,
                    color: color,
                  ),
                ),
              ),
            ),
            ShaderMask(
              shaderCallback: (rect) {
                return RadialGradient(
                  center: Alignment.center,
                  radius: 0.55,
                  colors: [
                    Colors.black,
                    Colors.black,
                    Colors.transparent,
                    Colors.transparent,
                  ],
                  stops: [0.0, 0.8, 0.9, 1.0],
                ).createShader(rect);
              },
              blendMode: BlendMode.dstIn,
              child: CoverImage(
                size: widget.coverSize,
                hash: widget.music.blurHash,
                imageUrl: widget.music.cover,
                isCircle: true,
              ),
            ),
          ],
        ),
      )
    );
  }
}
