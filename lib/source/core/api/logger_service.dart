import 'package:crud_app/source/core/manager/release_manager.dart';
import 'package:logger/logger.dart';

class LoggerService {
  final Logger logger;
  LoggerService({required this.logger});

  void logRequest({
    required String title,
    required String method,
    required String endpoint,
    required Map<String, dynamic> headers,
    dynamic body,
  }) {
    if (!AppRelease.isLogger) return;

    final formattedJson = {
      "type": "request",
      "title": title,
      "method": method,
      "endpoint": endpoint,
      "headers": headers,
      "body": body ?? {},
    };

    logger.i(formattedJson);
  }

  void logResponse({
    required String title,
    required int? statusCode,
    required dynamic data,
  }) {
    if (!AppRelease.isLogger) return;

    final formattedJson = {
      "type": "response",
      "title": title,
      "status_code": statusCode,
      "data": data,
    };

    logger.d(formattedJson);
  }

  void logError(String title, dynamic error) {
    if (!AppRelease.isLogger) return;

    logger.e('⛔ $title\n$error');
  }
}
