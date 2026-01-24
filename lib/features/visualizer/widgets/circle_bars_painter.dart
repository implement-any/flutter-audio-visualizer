import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';

class CircleBarsPainter extends CustomPainter {
  final VisualizerData visualizer;
  final ValueListenable<double> frameIndexListenable;
  final ValueListenable<double> fadeListenable;
  final ValueListenable<double> rotatable;

  // dirs cos, sin 연산 캐시
  List<Offset>? _dirs;
  int? _cachedBarCount;

  final Color color;

  final double coverSize;
  final double gap;
  final double maxLen;

  CircleBarsPainter({
    required this.visualizer,
    required this.coverSize,
    required this.gap,
    required this.maxLen,
    required this.color,
    required this.frameIndexListenable,
    required this.fadeListenable,
    required this.rotatable,
  }) : super(repaint: Listenable.merge([frameIndexListenable, fadeListenable, rotatable]));

  // 각 64개의 angle cos, sin 연산 캐싱 ( 1회만 )
  void _ensureDirs() {
    final count = visualizer.meta.barCount;
    if (_dirs != null && _cachedBarCount == count) return;
    _cachedBarCount = count;
    _dirs = List.generate(count, (i) {
      final angle = (i / count) * 2 * math.pi;
      return Offset(math.sin(angle), -math.cos(angle));
    });
  }

  @override
  void paint(Canvas canvas, Size size) {
    _ensureDirs();
    final dirs = _dirs!;

    final center = Offset(size.width / 2, size.height / 2);

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotatable.value);
    canvas.translate(-center.dx, -center.dy);

    final barCount = visualizer.meta.barCount;

    final radius = coverSize / 2 + gap;

    // 밝기 보정 ( Blur Hash 색상 값이 배경보다 어두우면 묻히는 경우가 있음 )
    final luminance = color.computeLuminance();
    final brighten = luminance >= (0.25 -  0.8).abs() ? 0.0 : luminance > 0.1 ? 0.5 : 0.3;

    final barPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.butt
      ..strokeWidth = 10;

    final circlePaint = Paint()
      ..color = color.withAlpha(190)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5;

    canvas.drawCircle(center, radius, circlePaint);

    for (int i = 0; i < barCount; i++) {
      final bar = visualizer.lerpBar(frameIndexListenable.value, i) * fadeListenable.value;

      final base = HSLColor.fromColor(color);
      final hue = (base.hue + bar) % 360;
      final barColor = base.withHue(hue).withLightness(brighten).toColor();

      barPaint.color = barColor.withAlpha(240);

      final dir = dirs[i];
      final half = (bar * maxLen * 0.5) / 1.5;
      final p1 = center + dir * (radius - half);
      final p2 = center + dir * (radius + half);

      canvas.drawLine(p1, p2, barPaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircleBarsPainter old) {
    return old.visualizer != visualizer;
  }
}
