import 'package:flutter_audio_visualizer/core/shell/shell_config.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/home/data/music_service.dart';
import 'package:flutter_audio_visualizer/shared/models/music.dart';

final musicProvider = FutureProvider<List<Music>>((ref) async {
  final musicList = await ref.read(musicServiceProvider).getMusicList();
  ref.read(backgroundConfigProvider.notifier).state = BackgroundConfig(hash: musicList[1].blurHash, rev: 1);
  return musicList;
});