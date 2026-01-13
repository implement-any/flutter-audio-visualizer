import 'package:just_audio/just_audio.dart';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Stream<PlayerState> get playingStream => _audioPlayer.playerStateStream;

  Future<void> setAudio(String audioId) async {
    await _audioPlayer.setUrl(
      "http://10.0.2.2:8080/audio/file/$audioId",
      headers: {'Accept': 'audio/wav'},
    );
  }

  Future<void> toggle() async {
    if(_audioPlayer.playing) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
  }

  Future<void> resetToPlay() async {
    await _audioPlayer.seek(Duration.zero);
    await _audioPlayer.play();
  }

  Future<void> dispose() async {
    await _audioPlayer.dispose();
  }
}
