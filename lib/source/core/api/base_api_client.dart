import 'package:crud_app/source/core/api/custom_logging_interceptor.dart';
import 'package:dio/dio.dart';
import 'status_code.dart';
import 'error_handling.dart';

//this is a typedef for a function that returns a Future<Response>
typedef RequestCallback = Future<Response> Function();

class BaseApiClient {
  final Dio dio;
  final CustomLoggingInterceptor loggingInterceptor;

  BaseApiClient({
    required this.dio,
    required this.loggingInterceptor,
  }) {
    dio.interceptors.add(loggingInterceptor); // ✅ Add it here
  }

  Future<Response> _handleRequest(RequestCallback request) async {
    try {
      final response = await request();
      if (response.statusCode == StatusCode.success ||
          response.statusCode == StatusCode.created) {
        return response;
      } else {
        throw Exception("Unexpected status code: ${response.statusCode}");
      }
    } on DioException catch (e) {
      throw Exception(ErrorHandling.fromDioException(e));
    } catch (e) {
     throw Exception("Unhandled exception occurred: ${e.toString()}");

    }
  }


  Future<Response> get(String path) {
    return _handleRequest(() => dio.get(path));
  }


  Future<Response> post(String path, {dynamic data}) {
    return _handleRequest(() => dio.post(path, data: data));
  }


  Future<Response> put(String path, {dynamic data}) {
    return _handleRequest(() => dio.put(path, data: data));
  }


  Future<Response> delete(String path) {
    return _handleRequest(() => dio.delete(path));
  }
  
  //Authentication methods
  Future<Response> login(String path){
   return _handleRequest(() => dio.post(path));
  }

  Future<Response> signUp(String path, {dynamic data}) {
    return _handleRequest(() => dio.post(path, data: data));
  }
  
  
}
