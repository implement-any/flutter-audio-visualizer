class Music {
  final String audioId;
  final String cover;
  final String blurHash;
  final String title;
  final String subTitle;

  Music({
    required this.audioId,
    required this.cover,
    required this.blurHash,
    required this.title,
    required this.subTitle,
  });

  factory Music.fromJson(Map<String, dynamic> json) {
    return Music(
      audioId: json['audioId'],
      cover: json['cover'],
      blurHash: json['blurHash'],
      title: json['title'],
      subTitle: json['subTitle'],
    );
  }
}
