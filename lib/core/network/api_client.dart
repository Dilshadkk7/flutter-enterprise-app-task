import 'package:dio/dio.dart';

class ApiClient {
  final Dio dio;
  // Base URL for the FakeStore API [cite: 12]
  static const String _baseUrl = 'https://fakestoreapi.com';

  ApiClient(this.dio) {
    dio.options.baseUrl = _baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 10);
  }

  Future<Response> get(String path) async {
    try {
      final response = await dio.get(path);
      return response;
    } on DioException {
      rethrow;
    }
  }
}