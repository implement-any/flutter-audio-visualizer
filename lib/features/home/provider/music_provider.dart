import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/features/home/data/music_service.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';

final musicProvider = FutureProvider<List<Music>>((ref) async {
  return await ref.read(musicServiceProvider).getMusicList();
});