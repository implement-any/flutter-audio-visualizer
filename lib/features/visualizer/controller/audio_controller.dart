import 'package:just_audio/just_audio.dart';
import 'package:flutter_audio_visualizer/shared/common/environment.dart';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();
  final Map<String, String> _headers = {'Accept': 'audio/wav'};

  Stream<PlayerState> get playingStream => _audioPlayer.playerStateStream;
  Stream<Duration> get positionStream => _audioPlayer.positionStream;
  ProcessingState get processingState => _audioPlayer.processingState;

  Future<void> setAudio(String audioId) async {
    final String url = "${Environment.baseUrl}/audio/file/$audioId";
    await _audioPlayer.setUrl(url, headers: _headers);
  }

  Future<void> resetToPlay() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }

  Future<void> toggle() async {
    if (_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }
}
