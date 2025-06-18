import 'package:crud_app/core/api/custom_logging_interceptor.dart';
import 'package:dio/dio.dart';
import '../end_points/end_points.dart';
import '../static_texts/request_texts.dart';
import '../error_handling/dio_exception_erros.dart';


class BaseApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EndPoints.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: {
      RequestTexts.contentType: RequestTexts.applicationJson,
    },
  ))..interceptors.add(CustomLoggingInterceptor());

  Future<Response> _handleRequest(
      Future<Response> Function() request, {
        required String title,
        required String method,
        required String endpoint,
        dynamic body,
      }) async {
    try {
      final response = await request();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return response;
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw DioExceptionErrors.fromDioException(e);
    } catch (e) {
      throw Exception("Unknown error: $e");
    }
  }


  // GET
  Future<Response> get(String path) async => await _handleRequest(
        () => _dio.get(path),
    title: "GET Request",
    method: "GET",
    endpoint: path,
  );

  // POST
  Future<Response> post(String path, {dynamic data}) async => await _handleRequest(
        () => _dio.post(path, data: data),
    title: "POST Request",
    method: "POST",
    endpoint: path,
    body: data,
  );

  // PUT
  Future<Response> put(String path, {dynamic data}) async => await _handleRequest(
        () => _dio.put(path, data: data),
    title: "PUT Request",
    method: "PUT",
    endpoint: path,
    body: data,
  );

  // DELETE
  Future<Response> delete(String path) async => await _handleRequest(
        () => _dio.delete(path),
    title: "DELETE Request",
    method: "DELETE",
    endpoint: path,
  );
}
