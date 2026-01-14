import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/core/network/dio_instance.dart';
import 'package:flutter_audio_visualizer/core/network/dio_provider.dart';

import 'package:flutter_audio_visualizer/shared/models/music.dart';

final musicServiceProvider = Provider((ref) {
  final dioInstance = ref.watch(dioProvider);
  return HomeService(dioInstance);
});

class HomeService {
  final DioInstance _dio;

  HomeService(this._dio);

  Future<List<Music>> getMusicList() async {
    final response = await _dio.get("/audio/file/list");
    final List<dynamic> musicList = response.data;
    return musicList.map((music) => Music.fromJson(music)).toList();
  }
}
