import '../../core/enums/user_role.dart';
import '../../core/error/exceptions.dart';
import '../../core/services/storage_service.dart';
import '../../core/utils/constants.dart';
import '../../domain/entities/auth_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remote;
  AuthRepositoryImpl({required this.remote});

  @override
  Future<AuthEntity> login({required String email, required String password}) async {
    final auth = await remote.login(email: email, password: password);
    await StorageService.to.setString(key: AppConstants.tokenKey,   value: auth.token);
    await StorageService.to.setString(key: AppConstants.roleKey,    value: auth.role);
    await StorageService.to.setString(key: AppConstants.userIdKey,  value: auth.id.toString());
    await StorageService.to.setString(key: AppConstants.userNameKey, value: auth.name);
    return auth;
  }

  @override
  Future<void> logout() async {
    await remote.logout();
    await StorageService.to.remove(key: AppConstants.tokenKey);
    await StorageService.to.remove(key: AppConstants.roleKey);
    await StorageService.to.remove(key: AppConstants.userIdKey);
    await StorageService.to.remove(key: AppConstants.userNameKey);
  }

  @override
  Future<void> forgotPassword(String email) => remote.forgotPassword(email);

  @override
  Future<void> verifyOtp({required String email, required String otp}) =>
      remote.verifyOtp(email: email, otp: otp);

  @override
  Future<void> resetPassword({required String email, required String otp, required String newPassword}) =>
      remote.resetPassword(email: email, otp: otp, newPassword: newPassword);

  @override
  Future<bool> isLoggedIn() async {
    final token = StorageService.to.getString(key: AppConstants.tokenKey);
    return token != null && token.isNotEmpty;
  }

  @override
  Future<UserRole> getCurrentRole() async {
    final role = StorageService.to.getString(key: AppConstants.roleKey) ?? 'user';
    return UserRoleX.fromString(role);
  }
}