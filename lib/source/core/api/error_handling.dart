// error_handling.dart

import 'package:dio/dio.dart';
import '../utils/status_code.dart';

class ErrorHandling {
  static const String connectionTimeout = 'Connection timeout';
  static const String sendTimeout = 'Send timeout';
  static const String responseTimeout = 'Response timeout';
  static const String badRequest = 'Bad request';
  static const String unauthorized = 'Unauthorized';
  static const String notFound = 'Not found';
  static const String requestCancelled = 'Request cancelled';
  static const String noConnection = 'No internet connection';
  static const String unknown = 'Unknown error';

  static String fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return connectionTimeout;
      case DioExceptionType.sendTimeout:
        return sendTimeout;
      case DioExceptionType.receiveTimeout:
        return responseTimeout;
      case DioExceptionType.connectionError:
        return noConnection;
      case DioExceptionType.cancel:
        return requestCancelled;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case StatusCode.badRequest:
            return badRequest;
          case StatusCode.unauthorized:
            return unauthorized;
          case StatusCode.notFound:
            return notFound;
          default:
            return 'Server error: ${e.response?.statusCode}';
        }
      case DioExceptionType.unknown:
      default:
        return unknown;
    }
  }

  static String handle(dynamic e) {
    if (e is DioException) {
      return fromDioException(e);
    } else if (e.toString().toLowerCase().contains('timeout')) {
      return connectionTimeout;
    } else {
      return '$unknown: ${e.toString()}';
    }
  }
}
