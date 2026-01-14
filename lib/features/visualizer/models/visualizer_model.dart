import 'dart:typed_data';

abstract class Reader {
  int getFrameIndex(Duration position);

  double clampedBar(int frameIndex, int barIndex);

  double lerpBar(double frame, int barIndex);
}

class VisualizerData implements Reader {
  final String audioId;
  final VisualizerMeta meta;
  final Uint8List framesBin;

  VisualizerData({
    required this.audioId,
    required this.meta,
    required this.framesBin,
  });

  // 재생 중인 위치로부터 frame 위치 구하기
  @override
  int getFrameIndex(Duration position) {
    final index = (position.inMilliseconds / meta.frameDurationMs).floor();
    if (index < 0) return 0;
    if (index >= meta.frameCount) return meta.frameCount - 1;
    return index;
  }

  // bin 복원 및 frame 정보 가져오기
  @override
  double clampedBar(int frameIndex, int barIndex) {
    final index = frameIndex * meta.barCount + barIndex;
    return framesBin[index] / 255.0;
  }

  @override
  double lerpBar(double frame, int barIndex) {
    final last = meta.frameCount - 1;

    final f = frame.clamp(0.0, last.toDouble());
    final i0 = f.floor();
    final i1 = (i0 + 1) > last ? last : (i0 + 1);
    final t = f - i0;

    final a = clampedBar(i0, barIndex);
    final b = clampedBar(i1, barIndex);

    return a + (b - a) * t;
  }
}

class VisualizerMeta {
  final String format;
  final int version;
  final int fftSize;
  final int hopSize;
  final int barCount;
  final int sampleRate;
  final int minHz;
  final int maxHz;
  final int frameCount;
  final double fps;
  final double frameDurationMs;

  VisualizerMeta({
    required this.format,
    required this.version,
    required this.fftSize,
    required this.hopSize,
    required this.barCount,
    required this.sampleRate,
    required this.minHz,
    required this.maxHz,
    required this.frameCount,
    required this.fps,
    required this.frameDurationMs,
  });

  factory VisualizerMeta.fromJson(Map<String, dynamic> json) {
    return VisualizerMeta(
      format: json['format'],
      version: (json['version'] as num).toInt(),
      fftSize: (json['fftSize'] as num).toInt(),
      hopSize: (json['hopSize'] as num).toInt(),
      barCount: (json['barCount'] as num).toInt(),
      sampleRate: (json['sampleRate'] as num).toInt(),
      minHz: (json['minHz'] as num).toInt(),
      maxHz: (json['maxHz'] as num).toInt(),
      frameCount: (json['frameCount'] as num).toInt(),
      fps: (json['fps'] as num).toDouble(),
      frameDurationMs: (json['frameDurationMs'] as num).toDouble(),
    );
  }
}
