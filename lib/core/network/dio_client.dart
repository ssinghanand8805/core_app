import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../utils/constants.dart';
import 'interceptors.dart';

class DioClient {
  static DioClient? _instance;
  late final Dio _dio;

  DioClient._() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.baseUrl,
        connectTimeout:
            const Duration(milliseconds: AppConstants.connectTimeout),
        receiveTimeout:
            const Duration(milliseconds: AppConstants.receiveTimeout),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
      ),
    );
    _dio.interceptors.addAll([
      PrettyDioLogger(
          requestHeader: true, requestBody: true, responseBody: true),
      AuthInterceptor(),
      ErrorInterceptor(),
    ]);
  }

  static DioClient get instance => _instance ??= DioClient._();
  Dio get dio => _dio;
}
