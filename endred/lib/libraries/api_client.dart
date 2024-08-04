import 'package:dio/dio.dart';

abstract class ApiClient {
  Future<dynamic> get(
    String url, {
    Options? options,
    String? baseUrl,
    Map<String, dynamic>? queryParameters = const {},
  });

  Future<dynamic> post(
    String url, {
    dynamic data,
    Options? options,
    String? baseUrl,
  });
}

class ApiClientImpl implements ApiClient {
  final Dio dio;

  ApiClientImpl({
    required this.dio,
  });

  @override
  Future<dynamic> get(
    String url, {
    Options? options,
    String? baseUrl,
    Map<String, dynamic>? queryParameters = const {},
  }) async {
    final apiUrl = '${baseUrl ?? ""}$url';

    try {
      final response = await dio.get(
        apiUrl,
        queryParameters: queryParameters,
      );
      return response;
    } catch (error) {
      final DioException dioException = error as DioException;
      return dioException.response;
    }
  }

  @override
  Future<dynamic> post(
    String url, {
    dynamic data,
    Options? options,
    String? baseUrl,
  }) async {
    final apiUrl = "${baseUrl ?? ""}$url";

    try {
      final response = await dio.post(apiUrl, data: data, options: options);
      return response;
    } catch (error) {
      final DioException dioException = error as DioException;
      return dioException.response;
    }
  }
}
