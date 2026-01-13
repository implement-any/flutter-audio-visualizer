import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/features/visualizer/data/visualizer_service.dart';
import 'package:flutter_audio_visualizer/features/visualizer/models/visualizer_model.dart';

final visualizerMetaProvider = FutureProvider.family<VisualizerMeta, String>((ref, audioId) async {
  return await ref.read(visualizerProvider).getVisualizerMeta(audioId);
});