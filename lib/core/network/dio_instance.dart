import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_audio_visualizer/shared/common/environment.dart';

class DioInstance {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: Environment.baseUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Content-Type": Headers.formUrlEncodedContentType},
    ),
  );

  void initInterceptor() {
    _dio.interceptors.add(LogInterceptor());
  }

  Future<Response<T>> get<T>(
    String path, {
    Options? options,
    CancelToken? cancelToken,
  }) async {
    return await _dio.get<T>(path, options: options, cancelToken: cancelToken);
  }
}

final dioProvider = Provider<DioInstance>((ref) {
  final dio = DioInstance();
  dio.initInterceptor();
  return dio;
});
