import 'dart:typed_data';

import 'package:dio/dio.dart';
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

  Future<VisualizerMeta> getVisualizerMeta(
    String audioId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get("/audio/visualizer/$audioId/meta");
    final dynamic data = response.data;
    return VisualizerMeta.fromJson(data);
  }

  Future<Uint8List> getVisualizerBin(
    String audioId, {
    CancelToken? cancelToken,
  }) async {
    final response = await _dio.get<List<int>>(
      "/audio/visualizer/$audioId/bin",
      options: Options(responseType: ResponseType.bytes),
      cancelToken: cancelToken,
    );
    return Uint8List.fromList(response.data!);
  }

  Future<VisualizerData> getVisualizer(
    String audioId, {
    CancelToken? cancelToken,
  }) async {
    final meta = await getVisualizerMeta(audioId, cancelToken: cancelToken);
    final framesBin = await getVisualizerBin(audioId, cancelToken: cancelToken);
    return VisualizerData(audioId: audioId, meta: meta, framesBin: framesBin);
  }
}
