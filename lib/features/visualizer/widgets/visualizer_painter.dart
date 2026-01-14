import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_audio_visualizer/features/visualizer/controller/audio_controller.dart';
import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';
import 'package:flutter_audio_visualizer/features/visualizer/provider/visualizer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';

class VisualizerRing extends ConsumerStatefulWidget {
  final String audioId;
  final AudioController controller;
  final double size;
  final double coverSize;

  const VisualizerRing({
    super.key,
    required this.audioId,
    required this.controller,
    required this.size,
    required this.coverSize,
  });

  @override
  ConsumerState<VisualizerRing> createState() => _VisualizerRingState();
}

class _VisualizerRingState extends ConsumerState<VisualizerRing>
    with SingleTickerProviderStateMixin {
  final ValueNotifier<List<double>> _bars = ValueNotifier<List<double>>([]);
  late final Ticker _ticker;

  VisualizerFrames? _frames;

  StreamSubscription<PlayerState>? _stateSub;
  bool _isPlaying = false;
  bool _isCompleted = false;

  // 스무딩 버퍼
  List<double> _smooth = const [];
  static const double _alphaPlay = 0.20;   // 재생 중 스무딩
  static const double _alphaIdle = 0.06;   // idle/완료에서 더 느리게 수렴(부드럽게 내려가게)

  // 오토 스케일(재생 중에만 사용)
  double _autoScale = 1.0;

  // 재생 전/정지 시 보여줄 기본 링(작은 값)
  List<double> _idleTarget = const [];

  @override
  void initState() {
    super.initState();

    // ✅ 재생 상태 구독
    _stateSub = widget.controller.playingStream.listen((state) {
      final wasPlaying = _isPlaying;
      _isPlaying = state.playing;
      _isCompleted = state.processingState == ProcessingState.completed;

      // ✅ 재생이 새로 시작될 때
      if (!wasPlaying && _isPlaying) {
        _autoScale = 1.0;
      }
    });


    _ticker = createTicker((_) {
      final frames = _frames;
      if (frames == null) return;

      // ✅ 매 프레임 position 샘플링
      final pos = widget.controller.position;

      // ✅ 상태에 따라 target 결정
      if (_isPlaying && !_isCompleted) {
        _tickPlaying(frames, pos);
      } else {
        _tickIdle(frames); // pause/stop/not started/completed 모두 여기
      }
    });

    _ticker.start();
  }

  void _initIdleTarget(int n) {
    _idleTarget = List<double>.filled(n, 0.08, growable: false);
  }

  void _ensureBuffers(int n) {
    if (_smooth.length != n) {
      _smooth = List<double>.filled(n, 0.0);
      _bars.value = List<double>.filled(n, 0.0);
      _initIdleTarget(n);
    }
  }

  void _applySmoothing(List<double> target, double alpha) {
    final n = target.length;
    final out = List<double>.filled(n, 0.0, growable: false);

    for (int i = 0; i < n; i++) {
      final t = (target[i].isFinite ? target[i] : 0.0).clamp(0.0, 1.0).toDouble();
      final s = _smooth[i];
      final next = s + (t - s) * alpha;
      _smooth[i] = next;
      out[i] = next;
    }

    _bars.value = out;
  }

  void _tickPlaying(VisualizerFrames frames, Duration pos) {
    final fps = frames.fps;
    if (!fps.isFinite || fps <= 0) return;

    final seconds = pos.inMicroseconds / 1e6;
    final f = seconds * fps;

    int idx = f.floor();
    double t = f - idx;

    if (idx < 0) { idx = 0; t = 0; }
    if (idx >= frames.framesCount - 1) { idx = frames.framesCount - 1; t = 0; }

    final a = frames.barsAt(idx);
    final b = (idx + 1 < frames.framesCount) ? frames.barsAt(idx + 1) : a;

    final n = a.length;
    if (n == 0) return;
    _ensureBuffers(n);

    // 보간 + max
    final targetRaw = List<double>.filled(n, 0.0, growable: false);
    double maxV = 0.0;

    for (int i = 0; i < n; i++) {
      final av = a[i].isFinite ? a[i] : 0.0;
      final bv = b[i].isFinite ? b[i] : 0.0;
      final tv = av + (bv - av) * t;
      targetRaw[i] = tv;
      if (tv.isFinite && tv > maxV) maxV = tv;
    }

    if (maxV <= 1e-6) maxV = 1.0;
    _autoScale = _autoScale + (maxV - _autoScale) * 0.05;
    if (_autoScale < 1e-6) _autoScale = 1.0;

    // 0..1 정규화
    final target = List<double>.filled(n, 0.0, growable: false);
    for (int i = 0; i < n; i++) {
      final v = (targetRaw[i] / _autoScale);
      target[i] = (v.isFinite ? v : 0.0).clamp(0.0, 1.0).toDouble();
    }

    _applySmoothing(target, _alphaPlay);
  }

  void _tickIdle(VisualizerFrames frames) {
    // frames에서 bar 길이만 가져오려고 frames를 받는 거고,
    // 실제 값은 idleTarget으로 수렴시키면 됨
    final n = frames.bars;
    if (n <= 0) return;

    _ensureBuffers(n);


    if (_isCompleted) {
      _applySmoothing(_idleTarget, _alphaIdle);
      return;
    }

    _applySmoothing(_idleTarget, _alphaIdle);
  }

  @override
  void dispose() {
    _stateSub?.cancel();
    _ticker.dispose();
    _bars.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncFrames = ref.watch(framesProvider(widget.audioId));

    return asyncFrames.when(
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
      data: (frames) {
        _frames ??= frames;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: CustomPaint(
            painter: _RadialBarsPainter(
              bars: _bars,
              coverRadius: widget.coverSize / 2,
              gap: 10,
              maxBarLength: 25,
              strokeWidth: 6,
            ),
          ),
        );
      },
    );
  }
}

class _RadialBarsPainter extends CustomPainter {
  final ValueListenable<List<double>> bars;
  final double coverRadius;
  final double gap;
  final double maxBarLength;
  final double strokeWidth;

  _RadialBarsPainter({
    required this.bars,
    required this.coverRadius,
    required this.gap,
    required this.maxBarLength,
    required this.strokeWidth,
  }) : super(repaint: bars);

  @override
  void paint(Canvas canvas, Size size) {
    final data = bars.value;
    final n = data.length;
    if (n == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final innerR = coverRadius + gap;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth
      ..color = Colors.black.withAlpha(150);

    const startAngle = -math.pi / 2;
    final step = (2 * math.pi) / n;

    for (int i = 0; i < n; i++) {
      final v0 = data[i].isFinite ? data[i] : 0.0;
      final v = (v0.clamp(0.0, 1.0));

      final a = startAngle + step * i;
      final dir = Offset(math.cos(a), math.sin(a));

      final p1 = center + dir * innerR;
      final p2 = center + dir * (innerR + maxBarLength * v);

      canvas.drawLine(p1, p2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _RadialBarsPainter oldDelegate) => false;
}
