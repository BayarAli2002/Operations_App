import 'package:dio/dio.dart';
import 'logger_service.dart';

class CustomLoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    LoggerService.logRequest(
      title: 'Outgoing Request',
      method: options.method,
      endpoint: options.path,
      headers: options.headers,
      body: options.data,
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    LoggerService.logResponse(
      title: 'Incoming Response',
      statusCode: response.statusCode,
      data: response.data,
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    LoggerService.logError('Request Error', err);
    super.onError(err, handler);
  }
}
