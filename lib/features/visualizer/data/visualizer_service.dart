import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/network/dio_instance.dart';
import 'package:flutter_audio_visualizer/core/network/dio_provider.dart';
import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';

final visualizerProvider = Provider<VisualizerClient>((ref) {
  final dioInstance = ref.watch(dioProvider);
  return VisualizerClient(dioInstance);
});

class VisualizerClient {
  final DioInstance _dio;

  VisualizerClient(this._dio);

  Future<VisualizerMeta> getVisualizerMeta(String audioId) async {
    final response = await _dio.get("/audio/visualizer/info/$audioId");
    final dynamic data = response.data;
    return VisualizerMeta.fromJson(data);
  }
}
