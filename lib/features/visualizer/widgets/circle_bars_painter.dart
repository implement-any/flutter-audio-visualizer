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
    required this.rotatable
  }) : super(repaint: Listenable.merge([frameIndexListenable, fadeListenable, rotatable]));

  // 각 64개의 angle cos, sin 연산 캐싱 ( 1회만 )
  void _ensureDirs() {
    final count = visualizer.meta.barCount;
    if(_dirs != null && _cachedBarCount == count) return;
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

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 6;

    for (int i = 0; i < barCount; i++) {
      final bar = visualizer.lerpBar(frameIndexListenable.value, i) * fadeListenable.value;

      final hueShift = ((i / barCount) * 20) - 30;
      final hsl = HSLColor.fromColor(color);
      final barColor = hsl.withHue((hsl.hue + hueShift) % 360).toColor();
      paint.color = barColor.withAlpha(255);

      final dir = dirs[i];
      final p1 = center + dir * radius;
      final p2 = center + dir * (radius + bar * maxLen);

      canvas.drawLine(p1, p2, paint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CircleBarsPainter old) {
    return old.visualizer != visualizer;
  }
}
