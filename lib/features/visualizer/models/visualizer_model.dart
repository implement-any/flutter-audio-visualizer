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

  factory VisualizerFrames.fromJson(Map<String, dynamic> json) {
    return VisualizerFrames(
      audio: json['audio'],
      fps: (json['fps'] as num).toDouble(),
      bars: json['bars'],
      frames: (json['frames'] as List)
          .map(
            (magnitudes) => (magnitudes as List)
                .map((magnitude) => (magnitude as num).toDouble())
                .toList(),
          )
          .toList(),
    );
  }
}

class VisualizerMeta {
  final String audio;
  final double fps;
  final int bars;

  VisualizerMeta({required this.audio, required this.fps, required this.bars});

  factory VisualizerMeta.fromJson(Map<String, dynamic> json) {
    return VisualizerMeta(
      audio: json['audio'],
      fps: (json['fps'] as num).toDouble(),
      bars: json['bars'],
    );
  }
}
