import 'package:dio/dio.dart';
import '../utils/logger.dart';
import '../services/storage_service.dart';
import '../error/exceptions.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = StorageService.to.getString(key: 'auth_token');
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    AppLogger.error('DIO ERROR: ${err.message}');
    handler.next(err);
  }
}

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw RequestTimeoutException();
      case DioExceptionType.connectionError:
        throw NetworkException();
      default:
        final statusCode = err.response?.statusCode;
        if (statusCode == 401) throw UnauthorizedException();
        throw ServerException(
          message: err.response?.data?['message'] ?? err.message ?? 'Server error',
          statusCode: statusCode,
        );
    }
  }
}