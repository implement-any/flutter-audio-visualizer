import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_audio_visualizer/features/visualizer/data/visualizer_service.dart';
import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';

final visualizerDataProvider = FutureProvider.autoDispose
.family<VisualizerData, String>((ref, audioId) async {
      ref.onDispose(() => print("Visualizer disposed: $audioId"));

      final client = ref.watch(visualizerProvider);

      final cancelToken = CancelToken();
      ref.onDispose(cancelToken.cancel);

      final link = ref.keepAlive();
      final timer = Timer(const Duration(seconds: 30), link.close);
      ref.onDispose(timer.cancel);

      return client.getVisualizer(audioId, cancelToken: cancelToken);
    });
