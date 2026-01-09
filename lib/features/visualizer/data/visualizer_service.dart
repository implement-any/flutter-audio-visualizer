import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/network/dio_instance.dart';
import 'package:flutter_audio_visualizer/core/network/dio_provider.dart';

final visualizerProvider = Provider<VisualizerClient>((ref) {
  final dioInstance = ref.watch(dioProvider);
  return VisualizerClient(dioInstance);
});

class VisualizerClient {
  final DioInstance _dio;

  VisualizerClient(this._dio);

  Future<List<String>> getAudioList() async {
    final response = await _dio.get("/audio/file/list");
    return List<String>.from(response.data);
  }

  Future<void> getVisualizerInfo(String audioName) async {
    final response = await _dio.get("/audio/visualizer/info/$audioName}");
  }
}
