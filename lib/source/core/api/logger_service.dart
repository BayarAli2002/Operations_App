import 'package:logger/logger.dart';
import '../../app/app_release.dart';

class LoggerService {
  static final Logger _logger = Logger();

  static void logRequest({
    required String title,
    required String method,
    required String endpoint,
    required Map<String, dynamic> headers,
    dynamic body,
  }) {
    if (!AppConfig.isLogger) return;

    final formattedJson = {
      "type": "request",
      "title": title,
      "method": method,
      "endpoint": endpoint,
      "headers": headers,
      "body": body ?? {},
    };

    _logger.i(formattedJson);
  }

  static void logResponse({
    required String title,
    required int? statusCode,
    required dynamic data,
  }) {
    if (!AppConfig.isLogger) return;

    final formattedJson = {
      "type": "response",
      "title": title,
      "status_code": statusCode,
      "data": data,
    };

    _logger.d(formattedJson);
  }

  static void logError(String title, dynamic error) {
    if (!AppConfig.isLogger) return;

    _logger.e('⛔ $title\n$error');
  }
}
