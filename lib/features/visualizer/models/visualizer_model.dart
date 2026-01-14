import 'dart:typed_data';

class VisualizerFrames {
  final String audio;
  final double fps;
  final int bars;
  final List<List<double>> frames;

  VisualizerFrames({
    required this.audio,
    required this.fps,
    required this.bars,
    required this.frames,
  });

  int get framesCount => frames.length;

  int indexOf(Duration position) {
    final seconds = position.inMicroseconds / 1e6;
    final idx = (seconds * fps).floor();
    if (idx < 0) return 0;
    if (idx >= framesCount) return framesCount - 1;
    return idx;
  }

  List<double> barsAt(int index) => frames[index];

  factory VisualizerFrames.fromJson(Map<String, dynamic> json) {
    final audio = json["audio"];
    final fps = (json['fps'] as num).toDouble();
    final bars = (json['bars'] as num).toInt();
    final rows = json['frames'] as List;

    final frames = rows
        .map((r) => (r as List).map((v) => (v as num).toDouble()).toList())
        .toList(growable: false);

    return VisualizerFrames(audio: audio, fps: fps, bars: bars, frames: frames);
  }
}

class VisualizerMeta {
  final String audio;
  final double fps;
  final int bars;
  final int framesCount;
  final double scaleMax;

  VisualizerMeta({
    required this.audio,
    required this.fps,
    required this.bars,
    required this.framesCount,
    required this.scaleMax,
  });

  factory VisualizerMeta.fromJson(Map<String, dynamic> json) {
    return VisualizerMeta(
      audio: json['audio'],
      fps: (json['fps'] as num).toDouble(),
      bars: (json['bars'] as num).toInt(),
      framesCount: (json['framesCount'] as num).toInt(),
      scaleMax: (json['scaleMax'] as num).toDouble(),
    );
  }
}

class VisualizerBinary {
  final VisualizerMeta meta;
  final Uint8List bytes;

  const VisualizerBinary({required this.meta, required this.bytes});
}
