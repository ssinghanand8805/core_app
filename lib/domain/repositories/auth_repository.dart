import '../entities/auth_entity.dart';
import '../../core/enums/user_role.dart';
import '../entities/payment_entity.dart';

abstract class AuthRepository {
  Future<AuthEntity> login({required String email, required String password});
  Future<void> logout();
  Future<void> forgotPassword(String email);
  Future<void> verifyOtp({required String email, required String otp});
  Future<void> resetPassword(
      {required String email,
      required String otp,
      required String newPassword});
  Future<bool> isLoggedIn();
  Future<UserRole> getCurrentRole();
}
