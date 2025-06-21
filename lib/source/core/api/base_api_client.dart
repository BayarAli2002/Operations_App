import 'package:crud_app/source/core/api/status_code.dart';
import 'package:dio/dio.dart';
import 'end_points.dart';
import '../utils/request_texts.dart';
import 'error_handling.dart';
import 'custom_logging_interceptor.dart';

class BaseApiClient {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: EndPoints.baseUrl,
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
      headers: {RequestTexts.contentType: RequestTexts.applicationJson},
    ),
  )..interceptors.add(CustomLoggingInterceptor());

  Future<Response> _handleRequest(Future<Response> Function() request) async {
    try {
      final response = await request();

      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        return response;
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw ErrorHandling.fromDioException(e);
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }

  // GET
  Future<Response> get(String path) async =>
      await _handleRequest(() => _dio.get(path));

  // POST
  Future<Response> post(String path, {dynamic data}) async =>
      await _handleRequest(() => _dio.post(path, data: data));

  // PUT
  Future<Response> put(String path, {dynamic data}) async =>
      await _handleRequest(() => _dio.put(path, data: data));

  // DELETE
  Future<Response> delete(String path) async =>
      await _handleRequest(() => _dio.delete(path));
}
