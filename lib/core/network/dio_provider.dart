import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/core/network/dio_instance.dart';

final dioProvider = Provider<DioInstance>((ref) {
  final dio = DioInstance();
  dio.initInterceptor();
  return dio;
});