import 'package:crud_app/source/core/manager/strings_manager.dart';
import 'package:dio/dio.dart';
import 'logger_service.dart';

class CustomLoggingInterceptor extends Interceptor {
  final LoggerService loggerService;
  CustomLoggingInterceptor({required this.loggerService});
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    loggerService.logRequest(
      title: StringsManager.outGoingRequest,
      method: options.method,
      endpoint: options.path,
      headers: options.headers,
      body: options.data,
    );
    super.onRequest(options, handler);
  }


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    loggerService.logResponse(
      title: StringsManager.incomingResponse,
      statusCode: response.statusCode,
      data: response.data,
    );
    super.onResponse(response, handler);
  }


  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    loggerService.logError(StringsManager.outGoingRequest, err);
    super.onError(err, handler);
  }


}
