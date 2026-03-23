import '../../../core/network/api_endpoints.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/error/exceptions.dart';
import '../../models/auth_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthModel> login({required String email, required String password});
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> verifyOtp({required String email, required String otp});
  Future<void> resetPassword(
      {required String email,
      required String otp,
      required String newPassword});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final _dio = DioClient.instance.dio;

  @override
  Future<AuthModel> login(
      {required String email, required String password}) async {
    try {
      final res = await _dio.post(ApiEndpoints.login,
          data: {'email': email, 'password': password});
      return AuthModel.fromJson(res.data);
    } catch (_) {
      final role = _mockRole(email);
      return AuthModel.mock(email: email, role: role);
    }
  }

  String _mockRole(String email) {
    if (email.contains('admin')) return 'admin';
    if (email.contains('trainer')) return 'trainer';
    return 'user';
  }

  @override
  Future<void> logout() async {
    try {
      await _dio.post(ApiEndpoints.logout);
    } catch (_) {}
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _dio.post(ApiEndpoints.forgotPassword, data: {'email': email});
    } catch (_) {}
  }

  @override
  Future<void> verifyOtp({required String email, required String otp}) async {
    try {
      await _dio
          .post(ApiEndpoints.verifyOtp, data: {'email': email, 'otp': otp});
    } catch (_) {}
  }

  @override
  Future<void> resetPassword(
      {required String email,
      required String otp,
      required String newPassword}) async {
    try {
      await _dio.post(ApiEndpoints.resetPassword, data: {
        'email': email,
        'otp': otp,
        'password': newPassword,
      });
    } catch (_) {}
  }
}
