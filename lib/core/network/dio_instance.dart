import 'package:dio/dio.dart';

class DioInstance {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://10.0.2.2:8080",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Content-Type": Headers.formUrlEncodedContentType},
    ),
  );

  void initInterceptor() {
    _dio.interceptors.add(LogInterceptor());
  }

  Future<Response> get(String path) async {
    return await _dio.get(path);
  }
}
