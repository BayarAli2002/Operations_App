import 'package:dio/dio.dart';
import '../end_points/end_points.dart';
import '../static_texts/request_texts.dart';
class BaseApiClient {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: EndPoints.baseUrl,
    connectTimeout: Duration(seconds: 10),
    receiveTimeout: Duration(seconds: 10),
    headers: { RequestTexts.contentType: RequestTexts.applicationJson },
  ));

  Future<Response> get(String path) async => await _dio.get(path);
  Future<Response> post(String path, {dynamic data}) async => await _dio.post(path, data: data);
  Future<Response> put(String path, {dynamic data}) async => await _dio.put(path, data: data);
  Future<void> delete(String path) async => await _dio.delete(path);
}
