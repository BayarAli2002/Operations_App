// error_handling.dart

import 'package:crud_app/source/core/translations/local_keys.g.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'status_code.dart';

class ErrorHandling {
  

  static String fromDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return LocaleKeys.connectionTimeout.tr();
      case DioExceptionType.sendTimeout:
        return LocaleKeys.sendTimeout.tr();
      case DioExceptionType.receiveTimeout:
        return LocaleKeys.responseTimeout.tr();
      case DioExceptionType.connectionError:
        return LocaleKeys.noConnection.tr();
      case DioExceptionType.cancel:
        return LocaleKeys.requestCancelled.tr();
      case DioExceptionType.badResponse:
        switch (e.response?.statusCode) {
          case StatusCode.badRequest:
            return LocaleKeys.badRequest.tr();
          case StatusCode.unauthorized:
            return LocaleKeys.unauthorized.tr();
          case StatusCode.notFound:
            return LocaleKeys.notFound.tr();
          default:
            return 'Server error: ${e.response?.statusCode}';
        }
      case DioExceptionType.unknown:
      default:
        return LocaleKeys.unknown.tr();
    }
  }

  static String handle(dynamic e) {
    if (e is DioException) {
      return fromDioException(e);
    } else if (e.toString().toLowerCase().contains('timeout')) {
      return LocaleKeys.connectionTimeout.tr();
    } else {
      return '${LocaleKeys.unknown.tr()}: ${e.toString()}';
    }
  }
}
