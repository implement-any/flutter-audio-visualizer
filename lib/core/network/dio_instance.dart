import 'package:dio/dio.dart';

class DioInstance {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: "http://localhost:8080",
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5),
      headers: {"Content-Type": Headers.formUrlEncodedContentType},
    ),
  );

  void initInterceptor() {
    _dio.interceptors.add(LogInterceptor());
  }

  Future<Response<void>> get(String path) async {
    return await _dio.get(path);
  }
}
