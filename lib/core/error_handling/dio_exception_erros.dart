import 'package:dio/dio.dart';

class DioExceptionErrors {
  static const String connectionTimeout = 'Connection timeout';
  static const String badRequest = 'Bad request';
  static const String unauthorized = 'Unauthorized';
  static const String notFound = 'Not found';
  static const String unknown = 'Unknown error';

  static String fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return connectionTimeout;
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case 400:
            return badRequest;
          case 401:
            return unauthorized;
          case 404:
            return notFound;
        }
        return unknown;
      default:
        return unknown;
    }
  }
}
